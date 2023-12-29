module Game.Update exposing (movePlayerInDirectionAndUpdateGame, placeBombeAndUpdateGame)

import Dict
import Direction exposing (Direction(..))
import Enemy
import Entity exposing (EffectType(..), Enemy(..), Entity(..), Item(..))
import Game exposing (Cell, Game)
import Game.Kill exposing (GameAndKill)
import Math
import Position
import Set


updateGame : Game -> Game
updateGame game =
    game.cells
        |> Dict.toList
        |> List.foldl
            updateCell
            game


updateCell : ( ( Int, Int ), Cell ) -> Game -> Game
updateCell ( position, cell ) game =
    case cell.entity of
        Enemy enemy ->
            game
                |> Enemy.update
                    { pos = position
                    , enemy = enemy
                    }
                |> Game.Kill.apply

        Particle _ ->
            game |> Game.remove position

        Stunned enemy ->
            game |> Game.update position (\_ -> Enemy enemy)

        _ ->
            game


movePlayerInDirectionAndUpdateGame : Direction -> ( Int, Int ) -> Game -> Game
movePlayerInDirectionAndUpdateGame dir location game =
    game
        |> Game.face dir
        |> movePlayer location
        |> Game.Kill.map updateGame
        |> Game.Kill.apply


movePlayer : ( Int, Int ) -> Game -> GameAndKill
movePlayer position game =
    let
        newLocation : ( Int, Int )
        newLocation =
            game.playerDirection
                |> Direction.toVector
                |> Position.addToVector position
    in
    if Math.posIsValid newLocation then
        case game.cells |> Dict.get newLocation |> Maybe.map .entity of
            Just (Enemy enemy) ->
                let
                    newPos =
                        game |> Game.findFirstEmptyCellInDirection newLocation game.playerDirection
                in
                { game =
                    game
                        |> Game.update newLocation
                            (\_ ->
                                enemy
                                    |> Enemy.stun game.playerDirection
                                    |> Stunned
                            )
                        |> Game.move { from = newLocation, to = newPos }
                        |> Maybe.withDefault game
                , kill =
                    if game.floor |> Set.member newPos then
                        []

                    else
                        [ newPos ]
                }

            Just (Particle _) ->
                { game =
                    game
                        |> Game.remove newLocation
                        |> Game.move { from = position, to = newLocation }
                        |> Maybe.withDefault game
                , kill = []
                }

            Just Crate ->
                { game =
                    game
                        |> pushCrate newLocation game.playerDirection
                        |> Maybe.andThen (Game.move { from = position, to = newLocation })
                        |> Maybe.map (takeItem newLocation)
                        |> Maybe.withDefault game
                , kill = []
                }

            Nothing ->
                { game =
                    if Set.member newLocation game.floor then
                        game
                            |> Game.move { from = position, to = newLocation }
                            |> Maybe.map (takeItem newLocation)
                            |> Maybe.withDefault game

                    else
                        game
                , kill = []
                }

            _ ->
                { game = game |> Game.face game.playerDirection
                , kill = []
                }

    else
        { game = game, kill = [] }


takeItem : ( Int, Int ) -> Game -> Game
takeItem pos game =
    game.items
        |> Dict.get pos
        |> Maybe.map (\item -> addItem item game)
        |> Maybe.map (\g -> { g | items = g.items |> Dict.remove pos })
        |> Maybe.withDefault game


addItem : Item -> Game -> Game
addItem item =
    case item of
        InactiveBomb ->
            Game.addBomb

        Heart ->
            Game.addLife


applyBomb : ( Int, Int ) -> Game -> Maybe Game
applyBomb position game =
    let
        newPosition =
            game.playerDirection
                |> Direction.toVector
                |> Position.addToVector position

        cell =
            Stunned PlacedBomb
    in
    if Math.posIsValid newPosition then
        case game.cells |> Dict.get newPosition |> Maybe.map .entity of
            Nothing ->
                if Set.member newPosition game.floor then
                    game
                        |> Game.insert newPosition cell
                        |> Just

                else
                    Nothing

            Just (Particle _) ->
                game
                    |> Game.insert newPosition cell
                    |> Just

            _ ->
                Nothing

    else
        Nothing


placeBombeAndUpdateGame : ( Int, Int ) -> Game -> Maybe Game
placeBombeAndUpdateGame playerCell game =
    Game.removeBomb game
        |> Maybe.andThen (applyBomb playerCell)
        |> Maybe.map updateGame


pushCrate : ( Int, Int ) -> Direction -> Game -> Maybe Game
pushCrate pos dir game =
    let
        newPos =
            dir
                |> Direction.toVector
                |> Position.addToVector pos
    in
    if
        Game.get newPos
            game
            == Nothing
            && Math.posIsValid newPos
    then
        if Set.member newPos game.floor then
            game
                |> Game.move { from = pos, to = newPos }

        else
            game
                |> Game.addFloor newPos
                |> Game.remove pos
                |> Just

    else
        Nothing

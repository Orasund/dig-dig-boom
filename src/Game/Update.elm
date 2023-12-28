module Game.Update exposing (movePlayerInDirectionAndUpdateGame, placeBombe)

import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Enemy
import Entity exposing (EffectType(..), Enemy(..), Entity(..), Item(..))
import Game exposing (Cell, Game)
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
                |> Enemy.update position enemy
                |> (\out ->
                        out.kill
                            |> List.foldl kill out.game
                   )

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
        |> updateGame


movePlayer : ( Int, Int ) -> Game -> Game
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
                game
                    |> Game.update newLocation
                        (\_ ->
                            enemy
                                |> Enemy.stun game.playerDirection
                                |> Stunned
                        )
                    |> Game.slide newLocation game.playerDirection

            Just (Particle _) ->
                game
                    |> Game.remove newLocation
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.withDefault game

            Just Crate ->
                game
                    |> pushCrate newLocation game.playerDirection
                    |> Maybe.andThen (Game.move { from = position, to = newLocation })
                    |> Maybe.map (takeItem newLocation)
                    |> Maybe.withDefault game

            Nothing ->
                if Set.member newLocation game.floor then
                    game
                        |> Game.move { from = position, to = newLocation }
                        |> Maybe.map (takeItem newLocation)
                        |> Maybe.withDefault game

                else
                    game

            _ ->
                game |> Game.face game.playerDirection

    else
        game


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
            Enemy PlacedBomb

        map =
            game.cells
    in
    if Math.posIsValid newPosition then
        case map |> Dict.get newPosition |> Maybe.map .entity of
            Nothing ->
                game
                    |> Game.insert newPosition cell
                    |> Just

            Just (Particle _) ->
                game
                    |> Game.insert newPosition cell
                    |> Just

            _ ->
                Nothing

    else
        Nothing


placeBombe : ( Int, Int ) -> Game -> Maybe Game
placeBombe playerCell game =
    Game.removeBomb game
        |> Maybe.andThen (applyBomb playerCell)


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


kill : ( Int, Int ) -> Game -> Game
kill pos game =
    game.cells
        |> Dict.get pos
        |> Maybe.map
            (\cell ->
                case cell.entity of
                    Player ->
                        Game.attackPlayer pos game
                            |> Maybe.withDefault game

                    Crate ->
                        { game
                            | cells =
                                game.cells |> Dict.insert pos { cell | entity = Particle Bone }
                        }

                    Enemy PlacedBomb ->
                        { game
                            | cells =
                                game.cells |> Dict.insert pos { cell | entity = Particle Smoke }
                        }

                    Enemy _ ->
                        { game
                            | cells =
                                game.cells |> Dict.insert pos { cell | entity = Particle Bone }
                        }

                    _ ->
                        game
            )
        |> Maybe.withDefault game

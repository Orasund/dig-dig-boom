module Game.Update exposing (checkIfWon, movePlayerInDirectionAndUpdateGame, placeBombeAndUpdateGame)

import Dict
import Direction exposing (Direction(..))
import Enemy
import Entity exposing (Enemy(..), Entity(..), Item(..), ParticleSort(..))
import Game exposing (Cell, Game)
import Game.Kill exposing (GameAndKill)
import Math
import Position
import Set


updateGame : Game -> Game
updateGame game =
    game.cells
        |> Dict.toList
        |> List.foldl updateCell (game |> Game.clearParticles)
        |> checkIfWon


checkIfWon : Game -> Game
checkIfWon game =
    if
        (Game.get ( 2, -1 ) game == Nothing)
            && (game.cells
                    |> Dict.filter
                        (\_ cell ->
                            case cell.entity of
                                Enemy _ ->
                                    True

                                _ ->
                                    False
                        )
                    |> (==) Dict.empty
               )
    then
        game |> Game.insert ( 2, -1 ) Door

    else
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
                    |> (\g ->
                            g
                                |> Game.move { from = newLocation, to = newPos }
                                |> Maybe.withDefault g
                       )
            , kill =
                if game.floor |> Set.member newPos then
                    []

                else
                    [ newPos ]
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

        Just Door ->
            { game =
                { game
                    | won = True
                    , cells =
                        game.cells
                            |> Dict.get position
                            |> Maybe.map
                                (\a ->
                                    game.cells
                                        |> Dict.insert newLocation a
                                        |> Dict.remove position
                                )
                            |> Maybe.withDefault game.cells
                }
            , kill = []
            }

        Nothing ->
            { game =
                if Math.posIsValid newLocation && Set.member newLocation game.floor then
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


takeItem : ( Int, Int ) -> Game -> Game
takeItem pos game =
    game.items
        |> Dict.get pos
        |> Maybe.andThen (\item -> addItem item game)
        |> Maybe.map (\g -> { g | items = g.items |> Dict.remove pos })
        |> Maybe.withDefault game


addItem : Item -> Game -> Maybe Game
addItem item =
    case item of
        Bomb ->
            Game.addBomb


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

            _ ->
                Nothing

    else
        Nothing


placeBombeAndUpdateGame : ( Int, Int ) -> Game -> Maybe Game
placeBombeAndUpdateGame playerCell game =
    case game.item of
        Just Bomb ->
            Game.removeItem game
                |> applyBomb playerCell
                |> Maybe.map updateGame

        _ ->
            Nothing


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

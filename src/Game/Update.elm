module Game.Update exposing (movePlayerInDirectionAndUpdateGame, placeBombe)

import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Enemy
import Entity exposing (EnemyType(..), Entity(..))
import Game exposing (Cell, Game)
import Math
import Position


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
        Enemy enemy _ ->
            game
                |> Enemy.tryAttacking position
                |> Maybe.withDefault game
                |> Enemy.enemyBehaviour position enemy

        Particle _ ->
            game |> Game.remove position

        Stunned enemy id ->
            game |> Game.update position (\_ -> Enemy enemy id)

        _ ->
            game


movePlayerInDirectionAndUpdateGame : Int -> Direction -> ( Int, Int ) -> Game -> Game
movePlayerInDirectionAndUpdateGame size dir location game =
    ( ( location, dir )
    , game |> Game.face location dir
    )
        |> movePlayer size
        |> updateGame


movePlayer : Int -> ( ( ( Int, Int ), Direction ), Game ) -> Game
movePlayer worldSize ( ( position, direction ), game ) =
    let
        outOfBound : Bool
        outOfBound =
            position
                |> (\( x, y ) ->
                        case direction of
                            Up ->
                                y == 0

                            Down ->
                                y == worldSize

                            Left ->
                                x == 0

                            Right ->
                                x == worldSize
                   )

        newLocation : ( Int, Int )
        newLocation =
            direction
                |> Direction.toVector
                |> Position.addToVector position
    in
    if outOfBound then
        game

    else
        case game.cells |> Dict.get newLocation |> Maybe.map .entity of
            Just InactiveBomb ->
                game
                    |> Game.addBomb
                    |> Game.remove newLocation
                    |> Game.move
                        { from = position
                        , to = newLocation
                        }
                    |> Maybe.withDefault game

            Just Heart ->
                game
                    |> Game.addLife
                    |> Game.remove newLocation
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.withDefault game

            Just (Enemy enemy id) ->
                game
                    |> Game.update newLocation (\_ -> Stunned enemy id)
                    |> Game.slide newLocation direction

            Just (Particle _) ->
                game
                    |> Game.remove newLocation
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.withDefault game

            Just Crate ->
                game.cells
                    |> pushCrate newLocation direction
                    |> Maybe.map
                        (\cells ->
                            { game | cells = cells }
                                |> Game.move { from = position, to = newLocation }
                                |> Maybe.withDefault game
                        )
                    |> Maybe.withDefault game

            Nothing ->
                game
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.withDefault game

            _ ->
                game |> Game.face position direction


applyBomb : ( ( Int, Int ), Direction ) -> Game -> Maybe Game
applyBomb ( position, direction ) game =
    let
        newPosition =
            direction
                |> Direction.toVector
                |> Position.addToVector position

        id : String
        id =
            let
                ( front_x, front_y ) =
                    newPosition
            in
            "bombe_"
                ++ String.fromInt front_x
                ++ "_"
                ++ String.fromInt front_y

        cell =
            Enemy PlacedBomb id

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


placeBombe : ( ( Int, Int ), Direction ) -> Game -> Maybe Game
placeBombe playerCell game =
    Game.removeBomb game
        |> Maybe.andThen (applyBomb playerCell)


pushCrate : ( Int, Int ) -> Direction -> Dict ( Int, Int ) Cell -> Maybe (Dict ( Int, Int ) Cell)
pushCrate pos dir cells =
    let
        newPos =
            dir
                |> Direction.toVector
                |> Position.addToVector pos
    in
    Dict.get pos cells
        |> Maybe.andThen
            (\from ->
                if
                    Dict.get newPos
                        cells
                        == Nothing
                        && Math.posIsValid newPos
                then
                    cells
                        |> Dict.insert newPos from
                        |> Dict.remove pos
                        |> Just

                else
                    Nothing
            )

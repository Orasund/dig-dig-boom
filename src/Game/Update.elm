module Game.Update exposing (movePlayerInDirectionAndUpdateGame, placeBombe)

import Cell exposing (Cell(..), EnemyType(..))
import Dict
import Direction exposing (Direction(..))
import Enemy
import Game exposing (Game)
import Math
import Player
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
    case cell of
        EnemyCell enemy _ ->
            game
                |> Enemy.tryAttacking position
                |> Maybe.withDefault game
                |> Enemy.enemyBehaviour position enemy

        EffectCell _ ->
            { game | cells = game.cells |> Dict.remove position }

        StunnedCell enemy id ->
            { game | cells = game.cells |> Dict.update position (always <| Just <| EnemyCell enemy id) }

        _ ->
            game


movePlayerInDirectionAndUpdateGame : Int -> Direction -> ( Int, Int ) -> Game -> Game
movePlayerInDirectionAndUpdateGame size dir location game =
    ( ( location, dir )
    , { game | cells = game.cells |> Player.face location dir }
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

        playerData =
            game.player
    in
    if outOfBound then
        game

    else
        case game.cells |> Dict.get newLocation of
            Just InactiveBombCell ->
                { game
                    | player = playerData |> Player.addBomb
                }
                    |> Game.remove newLocation
                    |> Game.move
                        { from = position
                        , to = newLocation
                        }
                    |> Maybe.withDefault game

            Just HeartCell ->
                { game
                    | player = playerData |> Player.addLife
                }
                    |> Game.remove newLocation
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.withDefault game

            Just (EnemyCell enemy id) ->
                game.cells
                    |> Dict.insert newLocation (StunnedCell enemy id)
                    |> (\cells -> { game | cells = cells })
                    |> Game.slide newLocation direction

            Just (EffectCell _) ->
                game
                    |> Game.remove newLocation
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.withDefault game

            Just CrateCell ->
                game.cells
                    |> Player.pushCrate newLocation direction
                    |> Maybe.map
                        (\cells ->
                            { game | cells = cells }
                                |> Game.move { from = position, to = newLocation }
                                |> Maybe.withDefault game
                        )
                    |> Maybe.withDefault game

            Nothing ->
                { game
                    | player = playerData
                }
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.withDefault game

            _ ->
                { game | cells = game.cells |> Player.face position direction }


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
            EnemyCell PlacedBomb id

        map =
            game.cells
    in
    if Math.posIsValid newPosition then
        case map |> Dict.get newPosition of
            Nothing ->
                { game
                    | cells =
                        game.cells |> Dict.insert newPosition cell
                }
                    |> Just

            Just (EffectCell _) ->
                { game
                    | cells =
                        game.cells |> Dict.insert newPosition cell
                }
                    |> Just

            _ ->
                Nothing

    else
        Nothing


placeBombe : ( ( Int, Int ), Direction ) -> Game -> Maybe Game
placeBombe playerCell game =
    Player.removeBomb game.player
        |> Maybe.andThen
            (\playerData ->
                { game | player = playerData }
                    |> applyBomb playerCell
            )

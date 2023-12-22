module Enemy exposing (..)

import Cell exposing (Cell(..), EffectType(..), EnemyType(..))
import Dict
import Direction exposing (Direction(..))
import Game exposing (Game)
import Math
import Position


enemyBehaviour : ( Int, Int ) -> EnemyType -> Game -> Game
enemyBehaviour currentLocation enemyType game =
    case enemyType of
        PlacedBomb ->
            [ Up, Down, Left, Right ]
                |> List.foldl
                    (placedBombeBehavoiur currentLocation)
                    game
                |> (\g ->
                        { g | cells = g.cells |> Dict.update currentLocation (always (Just (EffectCell Smoke))) }
                   )

        _ ->
            [ Up, Down, Left, Right ]
                |> List.foldl
                    (\dir out ->
                        if out == Nothing then
                            monsterMoveInDir currentLocation
                                dir
                                game

                        else
                            out
                    )
                    Nothing
                |> Maybe.withDefault game


findFirstInDirection : ( Int, Int ) -> Direction -> Game -> Maybe Cell
findFirstInDirection position direction game =
    let
        newPos =
            Direction.toCoord direction
                |> Position.addTo position
    in
    if Math.posIsValid newPos then
        case Dict.get newPos game.cells of
            Nothing ->
                findFirstInDirection newPos
                    direction
                    game

            Just a ->
                Just a

    else
        Nothing


monsterMoveInDir : ( Int, Int ) -> Direction -> Game -> Maybe Game
monsterMoveInDir position direction game =
    case findFirstInDirection position direction game of
        Just (PlayerCell _) ->
            game
                |> Game.move
                    { from = position
                    , to =
                        Direction.toCoord direction
                            |> Position.addTo position
                    }

        _ ->
            Nothing


placedBombeBehavoiur : ( Int, Int ) -> Direction -> Game -> Game
placedBombeBehavoiur location direction game =
    let
        newLocation =
            direction
                |> Direction.toCoord
                |> Position.addTo location
    in
    if Math.posIsValid newLocation then
        { game
            | cells =
                game.cells
                    |> Dict.update
                        newLocation
                        (\elem ->
                            case elem of
                                Just (EnemyCell _ _) ->
                                    Just <| EffectCell Bone

                                Just (WallCell solidType) ->
                                    Cell.decomposing solidType
                                        |> Maybe.map WallCell

                                Just CrateCell ->
                                    Just <| EffectCell Smoke

                                Nothing ->
                                    Just <| EffectCell Smoke

                                _ ->
                                    elem
                        )
        }

    else
        game


tryAttacking : ( Int, Int ) -> Game -> Maybe Game
tryAttacking position game =
    [ Up, Down, Left, Right ]
        |> List.filterMap
            (\direction ->
                let
                    newPos =
                        direction
                            |> Direction.toCoord
                            |> Position.addTo position
                in
                case
                    Dict.get newPos
                        game.cells
                of
                    Just (PlayerCell _) ->
                        Just newPos

                    _ ->
                        Nothing
            )
        |> List.head
        |> Maybe.map
            (\playerPos ->
                game
                    |> Game.attackPlayer playerPos
            )

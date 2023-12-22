module Enemy exposing (..)

import Cell exposing (Cell(..), EffectType(..), EnemyType(..))
import Component.Actor as Map exposing (Actor)
import Dict
import Direction exposing (Direction(..))
import Game
import Math
import Player exposing (Game)
import Position


enemyBehaviour : ( Int, Int ) -> EnemyType -> Actor -> Game -> Game
enemyBehaviour currentLocation enemyType ( playerLocation, _ ) game =
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
            ( location, direction ) |> Map.posFront 1
    in
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

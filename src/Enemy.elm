module Enemy exposing (..)

import Dict
import Direction exposing (Direction(..))
import Entity exposing (EffectType(..), EnemyType(..), Entity(..))
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
                        { g
                            | cells =
                                g.cells
                                    |> Dict.update currentLocation
                                        (Maybe.map (\cell -> { cell | entity = Particle Smoke }))
                        }
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


monsterMoveInDir : ( Int, Int ) -> Direction -> Game -> Maybe Game
monsterMoveInDir position direction game =
    case Game.findFirstInDirection position direction game of
        Just (Player _) ->
            game
                |> Game.move
                    { from = position
                    , to =
                        Direction.toVector direction
                            |> Position.addToVector position
                    }

        _ ->
            Nothing


placedBombeBehavoiur : ( Int, Int ) -> Direction -> Game -> Game
placedBombeBehavoiur location direction game =
    let
        newLocation =
            direction
                |> Direction.toVector
                |> Position.addToVector location
    in
    if Math.posIsValid newLocation then
        case
            game.cells
                |> Dict.get
                    newLocation
        of
            Just elem ->
                case elem.entity of
                    Enemy _ _ ->
                        game.cells
                            |> Dict.insert newLocation { elem | entity = Particle Bone }
                            |> (\cells -> { game | cells = cells })

                    Crate ->
                        game.cells
                            |> Dict.insert newLocation { elem | entity = Particle Smoke }
                            |> (\cells -> { game | cells = cells })

                    _ ->
                        game

            Nothing ->
                game |> Game.insert newLocation (Particle Smoke)

    else
        game


tryAttacking : ( Int, Int ) -> Game -> Maybe Game
tryAttacking position game =
    [ Up, Down, Left, Right ]
        |> List.filterMap
            (\direction ->
                Game.attackPlayer
                    (direction
                        |> Direction.toVector
                        |> Position.addToVector position
                    )
                    game
            )
        |> List.head

module Enemy exposing (..)

import Direction exposing (Direction(..))
import Entity exposing (EffectType(..), EnemyType(..), Entity(..))
import Game exposing (Game)
import Math
import Position


update : ( Int, Int ) -> EnemyType -> Game -> { game : Game, kill : List ( Int, Int ) }
update currentLocation enemyType game =
    case enemyType of
        PlacedBomb ->
            placedBombeBehavoiur currentLocation game

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
                |> Maybe.withDefault { game = game, kill = [] }


monsterMoveInDir : ( Int, Int ) -> Direction -> Game -> Maybe { game : Game, kill : List ( Int, Int ) }
monsterMoveInDir position direction game =
    case Game.findFirstInDirection position direction game of
        Just Player ->
            case
                game
                    |> Game.move
                        { from = position
                        , to =
                            Direction.toVector direction
                                |> Position.addToVector position
                        }
            of
                Just g ->
                    { game = g, kill = [] } |> Just

                Nothing ->
                    { game = game
                    , kill =
                        [ Direction.toVector direction
                            |> Position.addToVector position
                        ]
                    }
                        |> Just

        Just (Enemy PlacedBomb) ->
            game
                |> Game.move
                    { from = position
                    , to =
                        direction
                            |> Direction.mirror
                            |> Direction.toVector
                            |> Position.addToVector position
                    }
                |> Maybe.map
                    (\g ->
                        { game = g
                        , kill = []
                        }
                    )

        _ ->
            Nothing


placedBombeBehavoiur : ( Int, Int ) -> Game -> { game : Game, kill : List ( Int, Int ) }
placedBombeBehavoiur location game =
    [ Up, Down, Left, Right ]
        |> List.foldl
            (\direction output ->
                let
                    newLocation =
                        direction
                            |> Direction.toVector
                            |> Position.addToVector location
                in
                if Math.posIsValid newLocation then
                    if Game.get newLocation output.game == Nothing then
                        { output
                            | game =
                                output.game
                                    |> Game.insert newLocation (Particle Smoke)
                        }

                    else
                        { output | kill = newLocation :: output.kill }

                else
                    output
            )
            { game = game, kill = [ location ] }


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

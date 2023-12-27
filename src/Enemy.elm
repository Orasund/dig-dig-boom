module Enemy exposing (..)

import Direction exposing (Direction(..))
import Entity exposing (EffectType(..), Enemy(..), Entity(..))
import Game exposing (Game)
import Math
import Position


update : ( Int, Int ) -> Enemy -> Game -> { game : Game, kill : List ( Int, Int ) }
update pos enemyType game =
    let
        neighboringPlayer =
            Direction.asList
                |> List.map
                    (\dir ->
                        dir
                            |> Direction.toVector
                            |> Position.addToVector pos
                    )
                |> List.filter
                    (\newPos ->
                        Game.get newPos game == Just Player
                    )
    in
    (case enemyType of
        PlacedBomb ->
            updatePlacedBombe pos game

        Rat ->
            [ Up, Down, Left, Right ]
                |> List.foldl
                    (\dir out ->
                        if out == Nothing then
                            tryMovingRat pos
                                dir
                                game

                        else
                            out
                    )
                    Nothing
                |> Maybe.withDefault { game = game, kill = [] }

        Goblin dir ->
            updateGoblin pos dir game
    )
        |> (\out -> { out | kill = neighboringPlayer ++ out.kill })


updateGoblin : ( Int, Int ) -> Direction -> Game -> { game : Game, kill : List ( Int, Int ) }
updateGoblin pos direction game =
    let
        newPos =
            direction
                |> Direction.toVector
                |> Position.addToVector pos

        backPos =
            direction
                |> Direction.mirror
                |> Direction.toVector
                |> Position.addToVector pos

        moveToPosOr p fun g =
            if Math.posIsValid p then
                case Game.get p g of
                    Just Player ->
                        { game = g, kill = [ p ] }

                    Just _ ->
                        fun ()

                    Nothing ->
                        Game.move { from = pos, to = p } g
                            |> Maybe.map (\newGame -> { game = newGame, kill = [] })
                            |> Maybe.withDefault { game = g, kill = [] }

            else
                fun ()
    in
    moveToPosOr newPos
        (\() ->
            moveToPosOr backPos
                (\() ->
                    { game = game, kill = [] }
                )
                (Game.update pos
                    (\_ ->
                        Enemy (Goblin (Direction.mirror direction))
                    )
                    game
                )
        )
        game


tryMovingRat : ( Int, Int ) -> Direction -> Game -> Maybe { game : Game, kill : List ( Int, Int ) }
tryMovingRat position direction game =
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


updatePlacedBombe : ( Int, Int ) -> Game -> { game : Game, kill : List ( Int, Int ) }
updatePlacedBombe location game =
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

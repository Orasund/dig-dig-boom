module Game.Enemy exposing (..)

import Config
import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..), ParticleSort(..))
import Game exposing (Game)
import Game.Event exposing (GameAndKill)
import Math
import Position


update :
    { pos : ( Int, Int )
    , enemy : Enemy
    }
    -> Game
    -> GameAndKill
update args game =
    let
        neighboringPlayer =
            Direction.asList
                |> List.map
                    (\dir ->
                        dir
                            |> Direction.toVector
                            |> Position.addToVector args.pos
                    )
                |> List.filter
                    (\newPos ->
                        Game.get newPos game == Just Player
                    )
    in
    (case args.enemy of
        ActivatedBomb item ->
            case item of
                Bomb ->
                    updateDynamite args.pos game

                CrossBomb ->
                    updateCrossBomb args.pos game

        Goblin ->
            updateGoblin args.pos game |> Game.Event.none

        Orc dir ->
            updateOrc args.pos dir game |> Game.Event.none

        Doppelganger ->
            updateDoppelganger args.pos game |> Game.Event.none

        Rat ->
            updateRat args.pos game |> Game.Event.none
    )
        |> (\out -> { out | kill = neighboringPlayer ++ out.kill })


updateDoppelganger : ( Int, Int ) -> Game -> Game
updateDoppelganger pos game =
    let
        newPos =
            game.playerDirection
                |> Direction.mirror
                |> Direction.toVector
                |> Position.addToVector pos
    in
    case game |> Game.get newPos of
        Just Player ->
            game

        Nothing ->
            game
                |> tryMoving
                    { from = pos
                    , to = newPos
                    }
                |> Maybe.withDefault game

        _ ->
            game


updateOrc : ( Int, Int ) -> Direction -> Game -> Game
updateOrc pos direction game =
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
                    Just _ ->
                        fun ()

                    Nothing ->
                        case
                            tryMoving { from = pos, to = p } g
                                |> Maybe.map (\newGame -> newGame)
                        of
                            Just a ->
                                a

                            Nothing ->
                                fun ()

            else
                fun ()
    in
    moveToPosOr newPos
        (\() ->
            moveToPosOr backPos
                (\() ->
                    game
                )
                (Game.update pos
                    (\_ ->
                        Enemy (Orc (Direction.mirror direction))
                    )
                    game
                )
        )
        game


updateGoblin : ( Int, Int ) -> Game -> Game
updateGoblin position game =
    [ Up, Down, Left, Right ]
        |> List.foldl
            (\direction out ->
                if out == Nothing then
                    case Game.findFirstInDirection position direction game of
                        Just Player ->
                            game
                                |> tryMoving
                                    { from = position
                                    , to =
                                        Direction.toVector direction
                                            |> Position.addToVector position
                                    }

                        Just (Enemy (ActivatedBomb _)) ->
                            game
                                |> tryMoving
                                    { from = position
                                    , to =
                                        direction
                                            |> Direction.mirror
                                            |> Direction.toVector
                                            |> Position.addToVector position
                                    }

                        _ ->
                            Nothing

                else
                    out
            )
            Nothing
        |> Maybe.withDefault game


updateRat : ( Int, Int ) -> Game -> Game
updateRat position game =
    [ Up, Down, Left, Right ]
        |> List.foldl
            (\direction out ->
                if out == Nothing then
                    case Game.findFirstInDirection position direction game of
                        Just Player ->
                            game
                                |> tryMoving
                                    { from = position
                                    , to =
                                        Direction.toVector direction
                                            |> Position.addToVector position
                                    }

                        _ ->
                            Nothing

                else
                    out
            )
            Nothing
        |> Maybe.withDefault game


tryMoving : { from : ( Int, Int ), to : ( Int, Int ) } -> Game -> Maybe Game
tryMoving args game =
    if Dict.member args.to game.floor then
        Game.move args game

    else
        Nothing


updateDynamite : ( Int, Int ) -> Game -> GameAndKill
updateDynamite location game =
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
                    case Game.get newLocation output.game of
                        Just Player ->
                            output

                        _ ->
                            { output | kill = newLocation :: output.kill }

                else
                    output
            )
            { game = game, kill = [ location ] }


updateCrossBomb : ( Int, Int ) -> Game -> GameAndKill
updateCrossBomb pos game =
    [ Up, Down, Left, Right ]
        |> List.concatMap
            (\direction ->
                List.range 1 (Config.roomSize - 1)
                    |> List.map
                        (\n ->
                            direction
                                |> Direction.toVector
                                |> (\v -> { x = v.x * n, y = v.y * n })
                                |> Position.addToVector pos
                        )
            )
        |> List.foldl
            (\newPos output ->
                if Math.posIsValid newPos then
                    case Game.get newPos output.game of
                        Just Player ->
                            output

                        _ ->
                            { output | kill = newPos :: output.kill }

                else
                    output
            )
            { game = game |> Game.removeFloor pos
            , kill = [ pos ]
            }


stun : Direction -> Enemy -> Enemy
stun direction enemy =
    case enemy of
        Orc _ ->
            Orc (Direction.mirror direction)

        _ ->
            enemy

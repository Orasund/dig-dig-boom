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
        PlacedBomb item ->
            case item of
                Bomb ->
                    updateDynamite args.pos game

                CrossBomb ->
                    updateCrossBomb args.pos game

        Rat ->
            updateRat args.pos game |> Game.Event.none

        Goblin dir ->
            updateGoblin args.pos dir game |> Game.Event.none

        Golem ->
            updateGolem args.pos game |> Game.Event.none
    )
        |> (\out -> { out | kill = neighboringPlayer ++ out.kill })


updateGolem : ( Int, Int ) -> Game -> Game
updateGolem pos game =
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


updateGoblin : ( Int, Int ) -> Direction -> Game -> Game
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
                        Enemy (Goblin (Direction.mirror direction))
                    )
                    game
                )
        )
        game


updateRat : ( Int, Int ) -> Game -> Game
updateRat pos game =
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
        |> Maybe.withDefault game


tryMoving : { from : ( Int, Int ), to : ( Int, Int ) } -> Game -> Maybe Game
tryMoving args game =
    if Dict.member args.to game.floor then
        Game.move args game

    else
        Nothing


tryMovingRat : ( Int, Int ) -> Direction -> Game -> Maybe Game
tryMovingRat position direction game =
    case Game.findFirstInDirection position direction game of
        Just Player ->
            game
                |> tryMoving
                    { from = position
                    , to =
                        Direction.toVector direction
                            |> Position.addToVector position
                    }

        Just (Enemy (PlacedBomb _)) ->
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
        Goblin _ ->
            Goblin (Direction.mirror direction)

        _ ->
            enemy

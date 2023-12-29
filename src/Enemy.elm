module Enemy exposing (..)

import Direction exposing (Direction(..))
import Entity exposing (EffectType(..), Enemy(..), Entity(..))
import Game exposing (Game)
import Game.Kill exposing (GameAndKill)
import Math
import Position
import Set


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
        PlacedBomb ->
            updatePlacedBombe args.pos game

        Rat ->
            updateRat args.pos game |> Game.Kill.none

        Goblin dir ->
            updateGoblin args.pos dir game

        Golem ->
            updateGolem args.pos game
    )
        |> (\out -> { out | kill = neighboringPlayer ++ out.kill })


updateGolem : ( Int, Int ) -> Game -> GameAndKill
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
            { game = game, kill = [ newPos ] }

        Nothing ->
            game
                |> tryMoving
                    { from = pos
                    , to = newPos
                    }
                |> Maybe.map (\g -> { game = g, kill = [] })
                |> Maybe.withDefault { game = game, kill = [] }

        _ ->
            { game = game, kill = [] }


updateGoblin : ( Int, Int ) -> Direction -> Game -> GameAndKill
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
                        case
                            tryMoving { from = pos, to = p } g
                                |> Maybe.map (\newGame -> { game = newGame, kill = [] })
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
    if Set.member args.to game.floor then
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

        Just (Enemy PlacedBomb) ->
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


updatePlacedBombe : ( Int, Int ) -> Game -> GameAndKill
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
                    case Game.get newLocation output.game of
                        Nothing ->
                            { output
                                | game =
                                    output.game
                                        |> Game.insert newLocation (Particle Smoke)
                            }

                        Just Player ->
                            output

                        _ ->
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


stun : Direction -> Enemy -> Enemy
stun direction enemy =
    case enemy of
        Goblin _ ->
            Goblin (Direction.mirror direction)

        _ ->
            enemy

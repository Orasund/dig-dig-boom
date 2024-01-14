module Game.Update exposing (movePlayerInDirectionAndUpdateGame, placeBombeAndUpdateGame)

import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Floor(..), Item(..), ParticleSort(..))
import Game exposing (Cell, Game)
import Game.Enemy
import Game.Event exposing (Event(..), GameAndEvents)
import Gen.Sound exposing (Sound(..))
import Math
import Position


updateGame : { roomUnlocked : Bool } -> Game -> GameAndEvents
updateGame args game =
    game.cells
        |> Dict.toList
        |> List.foldl
            (\tuple -> Game.Event.andThen (updateCell args tuple))
            (game |> Game.clearParticles |> Game.Event.none)


updateCell : { roomUnlocked : Bool } -> ( ( Int, Int ), Cell ) -> Game -> GameAndEvents
updateCell args ( position, cell ) game =
    case cell.entity of
        Enemy enemy ->
            game
                |> Game.Enemy.update
                    { pos = position
                    , enemy = enemy
                    }

        Stunned enemy ->
            game
                |> Game.update position (\_ -> Enemy enemy)
                |> Game.Event.none

        LockedDoor ->
            if args.roomUnlocked then
                game
                    |> Game.remove position
                    |> Game.Event.none

            else
                game
                    |> Game.Event.none

        _ ->
            game |> Game.Event.none


movePlayerInDirectionAndUpdateGame :
    { hasKey : Bool
    , direction : Direction
    , roomUnlocked : Bool
    }
    -> ( Int, Int )
    -> Game
    -> Maybe GameAndEvents
movePlayerInDirectionAndUpdateGame args location game =
    game
        |> Game.face args.direction
        |> movePlayer { hasKey = args.hasKey } location
        |> Maybe.map (Game.Event.andThen (updateGame { roomUnlocked = args.roomUnlocked }))


movePlayer : { hasKey : Bool } -> ( Int, Int ) -> Game -> Maybe GameAndEvents
movePlayer args position game =
    let
        newLocation : ( Int, Int )
        newLocation =
            game.playerDirection
                |> Direction.toVector
                |> Position.addToVector position
    in
    case game.cells |> Dict.get newLocation |> Maybe.map .entity of
        {--Just (Enemy enemy) ->
            let
                newPos =
                    game |> Game.findFirstEmptyCellInDirection newLocation game.playerDirection
            in
            { game =
                game
                    |> Game.update newLocation
                        (\_ ->
                            enemy
                                |> Game.Enemy.stun game.playerDirection
                                |> Stunned
                        )
                    |> (\g ->
                            g
                                |> Game.move { from = newLocation, to = newPos }
                                |> Maybe.withDefault g
                       )
            , kill =
                if game.floor |> Dict.member newPos then
                    []

                else
                    [ newPos ]
            }--}
        Just ActiveSmallBomb ->
            game
                |> pushSmallBomb newLocation game.playerDirection
                |> Maybe.map (Game.Event.map (\g -> g |> Game.move { from = position, to = newLocation } |> Maybe.withDefault g))
                |> Maybe.map
                    (Game.Event.andThen
                        (\g ->
                            { game = takeItem newLocation g, kill = [ Fx Push ] }
                        )
                    )

        Just Crate ->
            game
                |> pushCrate newLocation game.playerDirection
                |> Maybe.map (Game.Event.map (\g -> g |> Game.move { from = position, to = newLocation } |> Maybe.withDefault g))
                |> Maybe.map (Game.Event.map (takeItem newLocation))
                |> Maybe.map
                    (Game.Event.andThen
                        (\g ->
                            { game = g, kill = [ Fx Push ] }
                        )
                    )

        Just (InactiveBomb item) ->
            let
                newPos =
                    game |> Game.findFirstEmptyCellInDirection newLocation game.playerDirection
            in
            { game =
                game
                    |> Game.update newLocation
                        (\_ ->
                            ActivatedBomb item
                                |> Game.Enemy.stun game.playerDirection
                                |> Stunned
                        )
                    |> (\g ->
                            g
                                |> Game.move { from = newLocation, to = newPos }
                                |> Maybe.withDefault g
                       )
            , kill =
                if game.floor |> Dict.member newPos then
                    [ Fx Push ]

                else
                    [ Kill newPos
                    , Fx Push
                    ]
            }
                |> Just

        Just Key ->
            { game =
                game
                    |> Game.remove newLocation
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.withDefault game
            , kill = [ AddKey ]
            }
                |> Just

        Just LockedDoor ->
            if args.hasKey then
                { game = game
                , kill = [ UnlockDoor ]
                }
                    |> Just

            else
                game |> Game.Event.none |> Just

        Just Diamant ->
            Just { game = game, kill = [ WinGame ] }

        Nothing ->
            if Math.posIsValid newLocation && Dict.member newLocation game.floor then
                game
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.map (takeItem newLocation)
                    |> Maybe.withDefault game
                    |> Game.Event.none
                    |> Just

            else
                Dict.get newLocation game.doors
                    |> Maybe.map
                        (\door ->
                            { game =
                                { game
                                    | won = True
                                    , cells =
                                        game.cells
                                            |> Dict.get position
                                            |> Maybe.map
                                                (\a ->
                                                    game.cells
                                                        |> Dict.insert newLocation a
                                                        |> Dict.remove position
                                                )
                                            |> Maybe.withDefault game.cells
                                    , playerPos = Just newLocation
                                }
                            , kill = [ MoveToRoom door.room ]
                            }
                        )

        _ ->
            {--{ game = game |> Game.face game.playerDirection
            , kill = []
            }--}
            Nothing


takeItem : ( Int, Int ) -> Game -> Game
takeItem pos game =
    game.items
        |> Dict.get pos
        |> Maybe.andThen (\item -> Game.addItem item game)
        |> Maybe.map (\g -> { g | items = g.items |> Dict.remove pos })
        |> Maybe.withDefault game


applyBomb : ( Int, Int ) -> Game -> Maybe Game
applyBomb position game =
    let
        newPosition =
            game.playerDirection
                |> Direction.toVector
                |> Position.addToVector position
    in
    game.item
        |> Maybe.andThen
            (\item ->
                if Math.posIsValid newPosition then
                    case game.cells |> Dict.get newPosition |> Maybe.map .entity of
                        Nothing ->
                            if Dict.member newPosition game.floor then
                                game
                                    |> Game.insert newPosition (Stunned (ActivatedBomb item))
                                    |> Just

                            else
                                Nothing

                        _ ->
                            Nothing

                else
                    Nothing
            )


placeBombeAndUpdateGame : { roomUnlocked : Bool } -> ( Int, Int ) -> Game -> Maybe GameAndEvents
placeBombeAndUpdateGame args playerCell game =
    applyBomb playerCell game
        |> Maybe.map Game.removeItem
        |> Maybe.map (updateGame args)


pushCrate : ( Int, Int ) -> Direction -> Game -> Maybe GameAndEvents
pushCrate pos dir game =
    let
        newPos =
            dir
                |> Direction.toVector
                |> Position.addToVector pos
    in
    if Math.posIsValid newPos then
        case Game.get newPos game of
            Nothing ->
                if Dict.member newPos game.floor then
                    game
                        |> Game.move { from = pos, to = newPos }
                        |> Maybe.map Game.Event.none

                else
                    game
                        |> Game.addFloor newPos CrateInLava
                        |> Game.remove pos
                        |> Game.Event.none
                        |> Just

            Just ActiveSmallBomb ->
                game
                    |> Game.remove newPos
                    |> Game.move { from = pos, to = newPos }
                    |> Maybe.map (\g -> { game = g, kill = [ Kill newPos ] })

            _ ->
                Nothing

    else
        Nothing


pushSmallBomb : ( Int, Int ) -> Direction -> Game -> Maybe GameAndEvents
pushSmallBomb pos dir game =
    let
        newPos =
            dir
                |> Direction.toVector
                |> Position.addToVector pos
    in
    if Math.posIsValid newPos then
        case Game.get newPos game of
            Nothing ->
                if Dict.member newPos game.floor then
                    game
                        |> Game.move { from = pos, to = newPos }
                        |> Maybe.map Game.Event.none

                else
                    game
                        |> Game.remove pos
                        |> Game.Event.none
                        |> Just

            Just _ ->
                game
                    |> Game.remove newPos
                    |> Game.move { from = pos, to = newPos }
                    |> Maybe.map (\g -> { game = g, kill = [ Kill newPos ] })

    else
        Nothing

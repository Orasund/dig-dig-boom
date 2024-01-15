module Game.Update exposing (movePlayerInDirectionAndUpdateGame, placeBombeAndUpdateGame)

import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Floor(..), Item(..), ParticleSort(..))
import Game exposing (Cell, Game)
import Game.Enemy
import Game.Event exposing (Event(..), GameAndEvents)
import Game.Player
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
        |> Game.Player.movePlayer { hasKey = args.hasKey } location
        |> Maybe.map (Game.Event.andThen (updateGame { roomUnlocked = args.roomUnlocked }))


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

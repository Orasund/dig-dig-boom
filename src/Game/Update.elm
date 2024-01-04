module Game.Update exposing (movePlayerInDirectionAndUpdateGame, placeBombeAndUpdateGame)

import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..), ParticleSort(..))
import Game exposing (Cell, Game)
import Game.Enemy
import Game.Event exposing (GameAndKill)
import Math
import Position


updateGame : Game -> GameAndKill
updateGame game =
    game.cells
        |> Dict.toList
        |> List.foldl
            (\tuple -> Game.Event.andThen (updateCell tuple))
            (game |> Game.clearParticles |> Game.Event.none)


updateCell : ( ( Int, Int ), Cell ) -> Game -> GameAndKill
updateCell ( position, cell ) game =
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

        _ ->
            game |> Game.Event.none


movePlayerInDirectionAndUpdateGame : Direction -> ( Int, Int ) -> Game -> Maybe GameAndKill
movePlayerInDirectionAndUpdateGame dir location game =
    game
        |> Game.face dir
        |> movePlayer location
        |> Maybe.map (Game.Event.andThen updateGame)


movePlayer : ( Int, Int ) -> Game -> Maybe GameAndKill
movePlayer position game =
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
        Just Crate ->
            { game =
                game
                    |> pushCrate newLocation game.playerDirection
                    |> Maybe.andThen (Game.move { from = position, to = newLocation })
                    |> Maybe.map (takeItem newLocation)
                    |> Maybe.withDefault game
            , kill = []
            }
                |> Just

        Just Door ->
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
                }
            , kill = []
            }
                |> Just

        Nothing ->
            if Math.posIsValid newLocation && Dict.member newLocation game.floor then
                game
                    |> Game.move { from = position, to = newLocation }
                    |> Maybe.map (takeItem newLocation)
                    |> Maybe.withDefault game
                    |> Game.Event.none
                    |> Just

            else
                Nothing

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
                                    |> Game.insert newPosition (Stunned (PlacedBomb item))
                                    |> Just

                            else
                                Nothing

                        _ ->
                            Nothing

                else
                    Nothing
            )


placeBombeAndUpdateGame : ( Int, Int ) -> Game -> Maybe GameAndKill
placeBombeAndUpdateGame playerCell game =
    applyBomb playerCell game
        |> Maybe.map Game.removeItem
        |> Maybe.map updateGame


pushCrate : ( Int, Int ) -> Direction -> Game -> Maybe Game
pushCrate pos dir game =
    let
        newPos =
            dir
                |> Direction.toVector
                |> Position.addToVector pos
    in
    if
        Game.get newPos
            game
            == Nothing
            && Math.posIsValid newPos
    then
        if Dict.member newPos game.floor then
            game
                |> Game.move { from = pos, to = newPos }

        else
            game
                |> Game.addFloor newPos
                |> Game.remove pos
                |> Just

    else
        Nothing

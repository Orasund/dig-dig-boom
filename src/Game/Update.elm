module Game.Update exposing (movePlayerInDirectionAndUpdateGame, placeBombeAndUpdateGame)

import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..), ParticleSort(..))
import Game exposing (Cell, Game)
import Game.Enemy
import Game.Kill exposing (GameAndKill)
import Math
import Position
import Set


updateGame : Game -> GameAndKill
updateGame game =
    game.cells
        |> Dict.toList
        |> List.foldl
            (\tuple -> Game.Kill.andThen (updateCell tuple))
            (game |> Game.clearParticles |> Game.Kill.none)


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
                |> Game.Kill.none

        _ ->
            game |> Game.Kill.none


movePlayerInDirectionAndUpdateGame : Direction -> ( Int, Int ) -> Game -> GameAndKill
movePlayerInDirectionAndUpdateGame dir location game =
    game
        |> Game.face dir
        |> movePlayer location
        |> Game.Kill.andThen updateGame


movePlayer : ( Int, Int ) -> Game -> GameAndKill
movePlayer position game =
    let
        newLocation : ( Int, Int )
        newLocation =
            game.playerDirection
                |> Direction.toVector
                |> Position.addToVector position
    in
    case game.cells |> Dict.get newLocation |> Maybe.map .entity of
        Just (Enemy enemy) ->
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
                if game.floor |> Set.member newPos then
                    []

                else
                    [ newPos ]
            }

        Just Crate ->
            { game =
                game
                    |> pushCrate newLocation game.playerDirection
                    |> Maybe.andThen (Game.move { from = position, to = newLocation })
                    |> Maybe.map (takeItem newLocation)
                    |> Maybe.withDefault game
            , kill = []
            }

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

        Nothing ->
            { game =
                if Math.posIsValid newLocation && Set.member newLocation game.floor then
                    game
                        |> Game.move { from = position, to = newLocation }
                        |> Maybe.map (takeItem newLocation)
                        |> Maybe.withDefault game

                else
                    game
            , kill = []
            }

        _ ->
            { game = game |> Game.face game.playerDirection
            , kill = []
            }


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
                            if Set.member newPosition game.floor then
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
        if Set.member newPos game.floor then
            game
                |> Game.move { from = pos, to = newPos }

        else
            game
                |> Game.addFloor newPos
                |> Game.remove pos
                |> Just

    else
        Nothing

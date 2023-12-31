module Game.Kill exposing (..)

import Dict
import Entity exposing (Enemy(..), Entity(..), ParticleSort(..))
import Game exposing (Game)


type alias GameAndKill =
    { game : Game, kill : List ( Int, Int ) }


none : Game -> GameAndKill
none game =
    { game = game, kill = [] }


apply : GameAndKill -> Game
apply output =
    output.kill
        |> List.foldl kill output.game


map : (Game -> Game) -> GameAndKill -> GameAndKill
map fun output =
    { output | game = fun output.game }


andThen : (Game -> GameAndKill) -> GameAndKill -> GameAndKill
andThen fun output =
    let
        newOutput =
            fun output.game
    in
    { output
        | game = newOutput.game
        , kill = newOutput.kill ++ output.kill
    }


kill : ( Int, Int ) -> Game -> Game
kill pos game =
    game.cells
        |> Dict.get pos
        |> Maybe.map
            (\cell ->
                case cell.entity of
                    Player ->
                        attackPlayer pos game
                            |> Maybe.withDefault game

                    Crate ->
                        { game
                            | particles =
                                game.particles |> Dict.insert pos Bone
                        }
                            |> Game.remove pos

                    Enemy PlacedBomb ->
                        { game
                            | particles =
                                game.particles |> Dict.insert pos Smoke
                        }
                            |> Game.remove pos

                    Enemy _ ->
                        { game
                            | particles =
                                game.particles |> Dict.insert pos Bone
                        }
                            |> Game.remove pos

                    _ ->
                        game
            )
        |> Maybe.withDefault game


attackPlayer : ( Int, Int ) -> Game -> Maybe Game
attackPlayer position game =
    game.cells
        |> Dict.get position
        |> Maybe.andThen
            (\cell ->
                case cell.entity of
                    Player ->
                        if game.item == Nothing then
                            { game
                                | cells =
                                    game.cells
                                        |> Dict.remove position
                                , particles =
                                    game.particles
                                        |> Dict.insert position Bone
                            }
                                |> Just

                        else
                            { game
                                | particles =
                                    game.particles
                                        |> Dict.insert position Bone
                            }
                                |> Game.removeItem
                                |> Just

                    _ ->
                        Nothing
            )

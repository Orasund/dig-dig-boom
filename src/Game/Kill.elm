module Game.Kill exposing (GameAndKill, andThen, apply, map, none)

import Dict
import Entity exposing (Enemy(..), Entity(..), ParticleSort(..))
import Game exposing (Game)


type alias GameAndKill =
    { game : Game, kill : List ( Int, Int ) }


none : Game -> GameAndKill
none game =
    { game = game, kill = [] }


apply : List ( Int, Int ) -> Game -> Game
apply kills game =
    kills
        |> List.foldl kill game
        |> checkIfWon


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
    case Game.get pos game of
        Just Player ->
            attackPlayer pos game
                |> Maybe.withDefault game

        Just Crate ->
            { game
                | particles =
                    game.particles |> Dict.insert pos Bone
            }
                |> Game.remove pos

        Just (Enemy (PlacedBomb _)) ->
            { game
                | particles =
                    game.particles |> Dict.insert pos Smoke
            }
                |> Game.remove pos

        Just (Enemy _) ->
            { game
                | particles =
                    game.particles |> Dict.insert pos Bone
            }
                |> Game.remove pos

        Nothing ->
            { game
                | particles =
                    game.particles |> Dict.insert pos Smoke
            }

        _ ->
            game


attackPlayer : ( Int, Int ) -> Game -> Maybe Game
attackPlayer position game =
    game.cells
        |> Dict.get position
        |> Maybe.andThen
            (\cell ->
                case cell.entity of
                    Player ->
                        --if game.item == Nothing then
                        { game
                            | cells =
                                game.cells
                                    |> Dict.remove position
                            , particles =
                                game.particles
                                    |> Dict.insert position Bone
                        }
                            |> Just

                    {--else
                            { game
                                | particles =
                                    game.particles
                                        |> Dict.insert position Bone
                            }
                                |> Game.removeItem
                                |> Just--}
                    _ ->
                        Nothing
            )


checkIfWon : Game -> Game
checkIfWon game =
    if
        (Game.get ( 2, -1 ) game == Nothing)
            && (game.cells
                    |> Dict.filter
                        (\_ cell ->
                            case cell.entity of
                                Enemy _ ->
                                    True

                                _ ->
                                    False
                        )
                    |> (==) Dict.empty
               )
    then
        game |> Game.insert ( 2, -1 ) Door

    else
        game

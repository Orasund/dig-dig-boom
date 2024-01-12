module Game.Event exposing
    ( Event(..)
    , GameAndEvents
    , andThen
    , kill
    , map
    , none
    )

import Dict
import Entity exposing (Enemy(..), Entity(..), ParticleSort(..))
import Game exposing (Game)
import Gen.Sound exposing (Sound)


type Event
    = Kill ( Int, Int )
    | Fx Sound
    | StageComplete


type alias GameAndEvents =
    { game : Game, kill : List Event }


none : Game -> GameAndEvents
none game =
    { game = game, kill = [] }



-- |> checkIfWon


map : (Game -> Game) -> GameAndEvents -> GameAndEvents
map fun output =
    { output | game = fun output.game }


andThen : (Game -> GameAndEvents) -> GameAndEvents -> GameAndEvents
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

        Just ActiveSmallBomb ->
            { game
                | particles =
                    game.particles |> Dict.insert pos Smoke
            }
                |> Game.remove pos

        Just (Enemy (ActivatedBomb _)) ->
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

        Just (InactiveBomb item) ->
            game |> Game.update pos (\_ -> Enemy (ActivatedBomb item))

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



{--checkIfWon : Game -> Game
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
        game--}

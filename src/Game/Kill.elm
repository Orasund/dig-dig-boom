module Game.Kill exposing (..)

import Dict
import Entity exposing (EffectType(..), Enemy(..), Entity(..))
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
                        Game.attackPlayer pos game
                            |> Maybe.withDefault game

                    Crate ->
                        { game
                            | cells =
                                game.cells |> Dict.insert pos { cell | entity = Particle Bone }
                        }

                    Enemy PlacedBomb ->
                        { game
                            | cells =
                                game.cells |> Dict.insert pos { cell | entity = Particle Smoke }
                        }

                    Enemy _ ->
                        { game
                            | cells =
                                game.cells |> Dict.insert pos { cell | entity = Particle Bone }
                        }

                    _ ->
                        game
            )
        |> Maybe.withDefault game

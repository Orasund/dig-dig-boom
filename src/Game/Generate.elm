module Game.Generate exposing (..)

import Config
import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Game)
import Game.Level exposing (Level)
import Game.Level1
import Position
import Random exposing (Generator)


new : Generator Game
new =
    let
        rec : Level -> Generator Game
        rec level =
            fromList level.content
                level.items
                |> Random.andThen
                    (\game ->
                        if level.valid game.cells then
                            Random.constant game

                        else
                            Random.lazy (\() -> rec level)
                    )
    in
    Random.uniform
        Game.Level1.level3
        []
        |> Random.andThen rec


shuffle : List a -> Generator (List a)
shuffle list =
    Random.list (List.length list) (Random.float 0 1)
        |> Random.map
            (\rand ->
                list
                    |> List.map2 Tuple.pair rand
                    |> List.sortBy Tuple.first
                    |> List.map Tuple.second
            )


fromList : List Entity -> List Item -> Generator Game
fromList entities items =
    Position.asGrid
        { columns = Config.mapSize - 1
        , rows = Config.mapSize - 1
        }
        |> shuffle
        |> Random.map
            (\list ->
                List.map2 Tuple.pair list entities
                    |> Dict.fromList
            )
        |> Random.andThen
            (\cells ->
                Position.asGrid
                    { columns = Config.mapSize
                    , rows = Config.mapSize
                    }
                    |> List.filter (\pos -> Dict.member pos cells |> not)
                    |> shuffle
                    |> Random.map
                        (\list ->
                            List.map2 Tuple.pair list items
                                |> Dict.fromList
                                |> Game.fromCells cells
                        )
            )

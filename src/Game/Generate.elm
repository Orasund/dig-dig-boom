module Game.Generate exposing (..)

import Cell exposing (Cell(..), EnemyType(..))
import Config
import Dict
import Direction exposing (Direction(..))
import Game exposing (Game)
import Game.Level1
import Random exposing (Generator)


new : Generator Game
new =
    let
        rec level =
            fromList level.content
                |> Random.andThen
                    (\game ->
                        if level.valid game.cells then
                            Random.constant game

                        else
                            Random.lazy (\() -> rec level)
                    )
    in
    Random.uniform
        Game.Level1.level2
        []
        |> Random.andThen rec


fromList : List Cell -> Generator Game
fromList cells =
    Random.list (Config.mapSize * Config.mapSize) (Random.float 0 1)
        |> Random.map
            (\list ->
                List.map2 Tuple.pair
                    list
                    (List.range 0 (Config.mapSize - 1)
                        |> List.concatMap
                            (\y ->
                                List.range 0 (Config.mapSize - 1)
                                    |> List.map (Tuple.pair y)
                            )
                    )
                    |> List.sortBy Tuple.first
                    |> List.map2 (\cell ( _, pos ) -> ( pos, cell ))
                        cells
                    |> Dict.fromList
                    |> Game.fromCells
            )

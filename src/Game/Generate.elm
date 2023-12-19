module Game.Generate exposing (..)

import Cell exposing (Cell(..), EnemyType(..), SolidType(..))
import Component.Map as Map
import Config
import Dict
import Direction exposing (Direction(..))
import Game
import Player exposing (Game)
import Random exposing (Generator)


new : Generator Game
new =
    Random.uniform
        [ EnemyCell Rat "Rat_0"
        , ItemCell
        , ItemCell
        , SolidCell DirtWall
        , SolidCell DirtWall
        , SolidCell StoneWall
        , PlayerCell Down
        ]
        []
        |> Random.andThen fromList


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


generateCell : Generator (Maybe Cell)
generateCell =
    Random.weighted
        ( 50, Random.constant Nothing )
        [ ( 15, Random.constant <| Just <| SolidCell <| DirtWall )
        , ( 5, Random.constant <| Just <| SolidCell StoneWall )
        , ( 1, Random.constant <| Just <| SolidCell StoneBrickWall )
        , ( 20, Random.constant <| Just <| ItemCell )
        , ( 5
          , Random.float 0 1
                |> Random.andThen
                    (\id ->
                        Random.constant <| Just <| EnemyCell Rat <| "Rat" ++ String.fromFloat id
                    )
          )
        , ( 3
          , Random.float 0 1
                |> Random.andThen
                    (\id ->
                        Random.constant <| Just <| EnemyCell Goblin <| "Goblin" ++ String.fromFloat id
                    )
          )
        , ( 1
          , Random.float 0 1
                |> Random.andThen
                    (\id ->
                        Random.constant <| Just <| EnemyCell Oger <| "Oger" ++ String.fromFloat id
                    )
          )
        ]
        |> Random.andThen identity

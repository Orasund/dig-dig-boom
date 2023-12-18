module Cell.Generate exposing (..)

import Cell exposing (Cell(..), EnemyType(..), SolidType(..))
import Random exposing (Generator)


generator : Generator (Maybe Cell)
generator =
    Random.weighted
        ( 30, Random.constant <| Just <| SolidCell <| DirtWall )
        [ ( 20, Random.constant <| Just <| SolidCell StoneWall )
        , ( 10, Random.constant <| Just <| SolidCell StoneBrickWall )
        , ( 30, Random.constant <| Just <| ItemCell )
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
        , ( 2
          , Random.float 0 1
                |> Random.andThen
                    (\id ->
                        Random.constant <| Just <| EnemyCell Oger <| "Oger" ++ String.fromFloat id
                    )
          )
        , ( 100, Random.constant Nothing )
        ]
        |> Random.andThen identity

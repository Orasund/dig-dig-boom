module World.Level exposing (empty, generate)

import Dict exposing (diff)
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Game)
import Game.Build exposing (BuildingBlock(..))
import Random exposing (Generator)


generate : Int -> Generator Game
generate difficulty =
    case difficulty of
        0 ->
            crateDungeon 0

        1 ->
            crateDungeon 1

        2 ->
            crateDungeon 2

        3 ->
            ratDungeon 0

        4 ->
            ratDungeon 1

        5 ->
            ratDungeon 2

        6 ->
            goblinDungeon 0

        7 ->
            goblinDungeon 1

        8 ->
            goblinDungeon 2

        9 ->
            golemDungeon 0

        10 ->
            golemDungeon 1

        11 ->
            golemDungeon 2

        _ ->
            golemDungeon 3


crateDungeon : Int -> Generator Game
crateDungeon difficulty =
    let
        maxCrate =
            difficulty + 1 |> min 4
    in
    Random.uniform
        [ "❌❌📦❌❌"
        , "❌⬜⬜⬜❌"
        , "❌⬜⬜⬜❌"
        , "❌⬜⬜⬜❌"
        , "❌⬜😊⬜❌"
        ]
        [ [ "📦⬜⬜⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "❌❌❌❌❌"
          , "⬜⬜📦⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "📦⬜⬜⬜⬜"
          , "⬜⬜❌⬜⬜"
          , "❌❌❌❌❌"
          , "⬜⬜📦⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "❌⬜⬜⬜❌"
          , "📦⬜⬜⬜📦"
          , "⬜⬜❌⬜⬜"
          , "⬜⬜📦⬜⬜"
          , "❌⬜😊⬜❌"
          ]
        ]
        |> Random.andThen
            (\layout ->
                Random.uniform
                    ([ List.repeat maxCrate (EntityBlock Crate)
                     , List.repeat 1 HoleBlock
                     ]
                        |> List.concat
                    )
                    [ [ List.repeat 1 (ItemBlock Bomb)
                      , List.repeat (maxCrate + 1) (EntityBlock Crate)
                      ]
                        |> List.concat
                    , [ List.repeat 1 HoleBlock
                      , List.repeat maxCrate (EntityBlock Crate)
                      ]
                        |> List.concat
                    ]
                    |> Random.andThen (Game.Build.generator layout)
            )


golemDungeon : Int -> Generator Game
golemDungeon stage =
    Random.uniform
        [ "❌⬜⬜⬜❌"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "❌⬜😊⬜❌"
        ]
        [ [ "⬜❌⬜❌⬜"
          , "⬜⬜❌⬜⬜"
          , "⬜⬜📦⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "❌⬜😊⬜❌"
          ]
        , [ "⬜❌⬜❌⬜"
          , "❌⬜⬜⬜❌"
          , "⬜⬜📦⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        ]
        |> Random.andThen
            (\layout ->
                Random.uniform
                    ([ List.repeat 3 (Enemy Golem |> EntityBlock)
                     , List.repeat 4 (ItemBlock Bomb)
                     , List.repeat 3 (EntityBlock Crate)
                     , List.repeat 1 HoleBlock
                     ]
                        |> List.concat
                    )
                    [ [ List.repeat 1 (Enemy Golem |> EntityBlock)
                      , List.repeat 1 (Enemy (Goblin Down) |> EntityBlock)
                      , List.repeat 1 (Enemy (Goblin Left) |> EntityBlock)
                      , List.repeat 4 (ItemBlock Bomb)
                      , List.repeat 3 (EntityBlock Crate)
                      , List.repeat 1 HoleBlock
                      ]
                        |> List.concat
                    , [ List.repeat 1 (Enemy Golem |> EntityBlock)
                      , List.repeat 2 (Enemy Rat |> EntityBlock)
                      , List.repeat 4 (ItemBlock Bomb)
                      , List.repeat 3 (EntityBlock Crate)
                      , List.repeat 1 HoleBlock
                      ]
                        |> List.concat
                    ]
                    |> Random.andThen (Game.Build.generator layout)
            )


goblinDungeon : Int -> Generator Game
goblinDungeon stage =
    Random.uniform
        [ "❌⬜⬜⬜❌"
        , "❌⬜⬜⬜❌"
        , "❌⬜⬜⬜❌"
        , "❌⬜⬜⬜❌"
        , "❌⬜😊⬜❌"
        ]
        [ [ "⬜⬜⬜⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "❌❌❌❌❌"
          , "⬜⬜📦⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "❌⬜⬜⬜❌"
          , "⬜⬜⬜⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "❌⬜😊⬜❌"
          ]
        ]
        |> Random.andThen
            (\layout ->
                Random.uniform
                    ([ List.repeat 1 (EntityBlock (Enemy (Goblin Right)))
                     , List.repeat 1 (EntityBlock (Enemy (Goblin Left)))
                     , List.repeat 1 (EntityBlock (Enemy (Goblin Down)))
                     , List.repeat 3 (ItemBlock Bomb)
                     , List.repeat 2 (EntityBlock Crate)
                     ]
                        |> List.concat
                    )
                    [ [ List.repeat 1 (EntityBlock (Enemy (Goblin Right)))
                      , List.repeat 1 (EntityBlock (Enemy (Goblin Left)))
                      , List.repeat 3 (ItemBlock Bomb)
                      , List.repeat 3 (EntityBlock Crate)
                      ]
                        |> List.concat
                    , [ List.repeat 1 (EntityBlock (Enemy (Goblin Down)))
                      , List.repeat 1 (EntityBlock (Enemy Rat))
                      , List.repeat 3 (ItemBlock Bomb)
                      , List.repeat 3 (EntityBlock Crate)
                      ]
                        |> List.concat
                    ]
                    |> Random.andThen (Game.Build.generator layout)
            )


ratDungeon : Int -> Generator Game
ratDungeon difficulty =
    let
        maxCrates =
            difficulty |> modBy 4

        maxEnemies =
            difficulty // 2 |> min 3 |> max 1

        maxBombs =
            maxEnemies - 1 |> max 1
    in
    Random.uniform
        [ "💣⬜⬜⬜💣"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "💣⬜😊⬜💣"
        ]
        [ [ "⬜⬜⬜⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "⬜⬜❌⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "📦⬜⬜⬜💣"
          , "⬜⬜⬜⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "💣⬜😊⬜📦"
          ]
        ]
        |> Random.andThen
            (\layout ->
                Random.uniform
                    ([ List.repeat maxEnemies (Enemy Rat |> EntityBlock)
                     , List.repeat (maxBombs + 1) (ItemBlock Bomb)
                     , List.repeat (maxCrates - 1) (EntityBlock Crate)
                     ]
                        |> List.concat
                    )
                    [ [ List.repeat maxEnemies (Enemy Rat |> EntityBlock)
                      , List.repeat maxBombs (ItemBlock Bomb)
                      , List.repeat maxCrates (EntityBlock Crate)
                      ]
                        |> List.concat
                    , [ List.repeat (maxEnemies - 1) (Enemy Rat |> EntityBlock)
                      , List.repeat 1 (Enemy (Goblin Down) |> EntityBlock)
                      , List.repeat maxBombs (ItemBlock Bomb)
                      , List.repeat maxCrates (EntityBlock Crate)
                      ]
                        |> List.concat
                    ]
                    |> Random.andThen (Game.Build.generator layout)
            )


randomLayout : Generator (List String)
randomLayout =
    Random.uniform
        [ "❌⬜⬜⬜❌"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "❌⬜😊⬜❌"
        ]
        [ [ "⬜⬜⬜⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "❌❌❌❌❌"
          , "⬜⬜📦⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "⬜❌⬜❌⬜"
          , "⬜⬜❌⬜⬜"
          , "⬜⬜📦⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "❌⬜😊⬜❌"
          ]
        , [ "❌⬜⬜⬜❌"
          , "❌⬜⬜⬜❌"
          , "❌⬜⬜⬜❌"
          , "❌⬜⬜⬜❌"
          , "❌⬜😊⬜❌"
          ]
        , [ "⬜⬜⬜⬜❌"
          , "⬜⬜⬜❌⬜"
          , "❌⬜⬜⬜❌"
          , "⬜❌⬜⬜⬜"
          , "❌⬜😊⬜⬜"
          ]
        , [ "⬜❌⬜❌⬜"
          , "❌⬜⬜⬜❌"
          , "⬜⬜📦⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        ]


empty : Generator Game
empty =
    Game.Build.generator
        [ "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜😊⬜⬜"
        ]
        []


ratLevel : List BuildingBlock
ratLevel =
    [ List.repeat 4 (EntityBlock (Enemy Rat))
    , List.repeat 3 (EntityBlock Crate)
    , List.repeat 5 (ItemBlock Bomb)
    , [ HoleBlock
      ]
    ]
        |> List.concat


goblinLevel : List BuildingBlock
goblinLevel =
    [ List.repeat 3 (EntityBlock Crate)
    , [ Enemy (Goblin Left) |> EntityBlock
      , Enemy (Goblin Right) |> EntityBlock
      , Enemy (Goblin Down) |> EntityBlock
      , Enemy (Goblin Up) |> EntityBlock
      , HoleBlock
      ]
    , List.repeat 5 (ItemBlock Bomb)
    ]
        |> List.concat


golemLevel : List BuildingBlock
golemLevel =
    [ List.repeat 3 (EntityBlock (Enemy Golem))
    , List.repeat 4 (ItemBlock Bomb)
    , List.repeat 3 (EntityBlock Crate)
    , [ HoleBlock
      ]
    ]
        |> List.concat


finalLevel : List BuildingBlock
finalLevel =
    [ List.repeat 4 (ItemBlock Bomb)
    , List.repeat 3 (EntityBlock Crate)
    , [ EntityBlock (Enemy Rat)
      , Enemy (Goblin Left) |> EntityBlock
      , EntityBlock (Enemy Golem)
      , HoleBlock
      ]
    ]
        |> List.concat

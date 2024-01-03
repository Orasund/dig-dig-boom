module World.Level exposing (empty, generate)

import Array
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Game)
import Game.Build exposing (BuildingBlock(..))
import Random exposing (Generator)


generate : Int -> Generator Game
generate difficulty =
    Array.get difficulty dungeons
        |> Maybe.withDefault golemDungeon


dungeons : Array.Array (Generator Game)
dungeons =
    [ crateDungeonNoPushingIntoLava
    , crateDungeon 2
    , ratDungeon 1
    , goblinDungeon
    ]
        |> Array.fromList


crateDungeonNoPushingIntoLava : Generator Game
crateDungeonNoPushingIntoLava =
    Random.uniform
        [ "❌⬜⬜⬜❌"
        , "❌⬜⬜⬜❌"
        , "❌⬜⬜⬜❌"
        , "❌⬜⬜⬜❌"
        , "❌⬜😊⬜❌"
        ]
        [ [ "⬜⬜⬜⬜⬜"
          , "⬜📦⬜⬜⬜"
          , "⬜❌❌❌⬜"
          , "📦⬜⬜⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "⬜⬜⬜⬜⬜"
          , "⬜⬜⬜📦⬜"
          , "⬜❌❌❌⬜"
          , "⬜⬜⬜⬜📦"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "⬜⬜⬜📦⬜"
          , "⬜📦❌⬜⬜"
          , "⬜⬜⬜⬜📦"
          , "⬜⬜❌⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "⬜📦⬜⬜⬜"
          , "⬜⬜❌📦⬜"
          , "📦⬜⬜⬜⬜"
          , "⬜⬜❌⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "⬜⬜⬜⬜⬜"
          , "⬜❌❌⬜⬜"
          , "⬜⬜⬜⬜⬜"
          , "⬜⬜❌❌⬜"
          , "⬜⬜😊⬜⬜"
          ]
        ]
        |> Random.andThen
            (\layout ->
                Random.uniform
                    ([ List.repeat 4 (EntityBlock Crate)
                     ]
                        |> List.concat
                    )
                    [ [ List.repeat 3 (EntityBlock Crate)
                      ]
                        |> List.concat
                    ]
                    |> Random.andThen (Game.Build.generator layout)
            )


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


golemDungeon : Generator Game
golemDungeon =
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


goblinDungeon : Generator Game
goblinDungeon =
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
            difficulty + 1

        maxEnemies =
            difficulty |> min 3 |> max 1

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

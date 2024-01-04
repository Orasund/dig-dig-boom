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
        |> Maybe.withDefault goblinDungeon


dungeons : Array.Array (Generator Game)
dungeons =
    [ crateDungeonNoLavaNoBombs
    , crateDungeonNoBombs
    , crateDungeonNoLava
    , ratDungeon 1
    ]
        |> Array.fromList


crateDungeonNoLavaNoBombs : Generator Game
crateDungeonNoLavaNoBombs =
    Random.uniform
        (Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜📦⬜📦⬜"
            , "📦📦📦📦📦"
            , "📦⬜⬜📦⬜"
            , "⬜⬜😊⬜⬜"
            ]
            []
        )
        [ Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "📦⬜⬜📦⬜"
            , "📦📦📦📦📦"
            , "📦⬜⬜⬜📦"
            , "⬜⬜😊⬜⬜"
            ]
            []
        , Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜📦📦📦📦"
            , "📦⬜⬜📦⬜"
            , "⬜📦📦⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
            []
        , Game.Build.generator
            [ "⬜📦⬜📦⬜"
            , "⬜⬜📦⬜⬜"
            , "📦📦📦📦📦"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
            []
        ]
        |> Random.andThen identity


crateDungeonNoBombs : Generator Game
crateDungeonNoBombs =
    Random.uniform
        [ "❌❌📦❌❌"
        , "❌⬜⬜📦❌"
        , "❌⬜📦⬜❌"
        , "❌📦⬜⬜❌"
        , "❌⬜😊⬜❌"
        ]
        [ [ "📦⬜📦⬜⬜"
          , "⬜📦⬜📦⬜"
          , "❌❌❌❌❌"
          , "⬜⬜📦⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "📦⬜⬜📦⬜"
          , "⬜📦❌⬜📦"
          , "❌❌❌❌❌"
          , "⬜⬜📦⬜📦"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "❌📦⬜⬜❌"
          , "📦⬜⬜⬜📦"
          , "⬜⬜❌📦⬜"
          , "📦⬜📦⬜📦"
          , "❌⬜😊⬜❌"
          ]
        ]
        |> Random.andThen
            (\layout ->
                Game.Build.generator layout []
            )


crateDungeonNoLava : Generator Game
crateDungeonNoLava =
    Random.uniform
        (Game.Build.generator
            [ "⬜⬜📦⬜⬜"
            , "⬜📦⬜📦⬜"
            , "📦📦📦📦📦"
            , "📦⬜💣📦⬜"
            , "⬜⬜😊⬜⬜"
            ]
            []
        )
        [ Game.Build.generator
            [ "⬜⬜📦⬜⬜"
            , "📦⬜⬜📦⬜"
            , "📦📦📦📦📦"
            , "📦⬜💣⬜📦"
            , "⬜⬜😊⬜⬜"
            ]
            []
        , Game.Build.generator
            [ "⬜⬜📦⬜⬜"
            , "⬜📦📦📦📦"
            , "📦⬜💣📦⬜"
            , "⬜📦📦⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
            []
        , Game.Build.generator
            [ "⬜📦📦📦⬜"
            , "⬜⬜📦⬜⬜"
            , "📦📦📦📦📦"
            , "⬜⬜💣⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
            []
        ]
        |> Random.andThen identity


doppelgangerDungeon : Generator Game
doppelgangerDungeon =
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
                    ([ List.repeat 3 (Enemy Doppelganger |> EntityBlock)
                     , List.repeat 4 (ItemBlock Bomb)
                     , List.repeat 3 (EntityBlock Crate)
                     , List.repeat 1 HoleBlock
                     ]
                        |> List.concat
                    )
                    [ [ List.repeat 1 (Enemy Doppelganger |> EntityBlock)
                      , List.repeat 1 (Enemy (Orc Down) |> EntityBlock)
                      , List.repeat 1 (Enemy (Orc Left) |> EntityBlock)
                      , List.repeat 4 (ItemBlock Bomb)
                      , List.repeat 3 (EntityBlock Crate)
                      , List.repeat 1 HoleBlock
                      ]
                        |> List.concat
                    , [ List.repeat 1 (Enemy Doppelganger |> EntityBlock)
                      , List.repeat 2 (Enemy Goblin |> EntityBlock)
                      , List.repeat 4 (ItemBlock Bomb)
                      , List.repeat 3 (EntityBlock Crate)
                      , List.repeat 1 HoleBlock
                      ]
                        |> List.concat
                    ]
                    |> Random.andThen (Game.Build.generator layout)
            )


orcDungeon : Generator Game
orcDungeon =
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
                    ([ List.repeat 1 (EntityBlock (Enemy (Orc Right)))
                     , List.repeat 1 (EntityBlock (Enemy (Orc Left)))
                     , List.repeat 1 (EntityBlock (Enemy (Orc Down)))
                     , List.repeat 3 (ItemBlock Bomb)
                     , List.repeat 2 (EntityBlock Crate)
                     ]
                        |> List.concat
                    )
                    [ [ List.repeat 1 (EntityBlock (Enemy (Orc Right)))
                      , List.repeat 1 (EntityBlock (Enemy (Orc Left)))
                      , List.repeat 3 (ItemBlock Bomb)
                      , List.repeat 3 (EntityBlock Crate)
                      ]
                        |> List.concat
                    , [ List.repeat 1 (EntityBlock (Enemy (Orc Down)))
                      , List.repeat 1 (EntityBlock (Enemy Goblin))
                      , List.repeat 3 (ItemBlock Bomb)
                      , List.repeat 3 (EntityBlock Crate)
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
                    ([ List.repeat 1 (EntityBlock (Enemy Goblin))
                     , List.repeat 1 (EntityBlock (Enemy Goblin))
                     , List.repeat 1 (EntityBlock (Enemy Goblin))
                     , List.repeat 3 (ItemBlock Bomb)
                     , List.repeat 2 (EntityBlock Crate)
                     ]
                        |> List.concat
                    )
                    [ [ List.repeat 1 (EntityBlock (Enemy Goblin))
                      , List.repeat 1 (EntityBlock (Enemy Goblin))
                      , List.repeat 3 (ItemBlock Bomb)
                      , List.repeat 3 (EntityBlock Crate)
                      ]
                        |> List.concat
                    , [ List.repeat 1 (EntityBlock (Enemy Goblin))
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
                      , List.repeat 1 (Enemy (Orc Down) |> EntityBlock)
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

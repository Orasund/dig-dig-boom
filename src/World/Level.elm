module World.Level exposing (..)

import Config
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Game)
import Game.Build exposing (BuildingBlock(..))
import Random exposing (Generator)
import World.Trial


type alias Level =
    { dungeon : Int
    , stage : Int
    }


first : Level
first =
    { dungeon = 0
    , stage = 0
    }


next : Level -> Level
next level =
    { level | stage = level.stage + 1 }


generate : Level -> Generator Game
generate level =
    case level.dungeon of
        0 ->
            tutorialDungeon level.stage

        1 ->
            goblinDungeon level.stage

        2 ->
            golemDungeon level.stage

        _ ->
            Random.map2 Game.Build.generator
                randomLayout
                (Random.uniform
                    golemLevel
                    [ ratLevel
                    , goblinLevel
                    , finalLevel
                    ]
                )
                |> Random.andThen identity


golemDungeon : Int -> Generator Game
golemDungeon stage =
    case stage // Config.stageRepetition of
        0 ->
            [ List.repeat 1 (EntityBlock (Enemy Golem))
            , List.repeat 1 (EntityBlock Crate)
            , List.repeat 1 (ItemBlock InactiveBomb)
            , List.repeat 1 HoleBlock
            ]
                |> List.concat
                |> Game.Build.generator
                    [ "❌⬜⬜⬜❌"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜💚⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "❌⬜😊⬜❌"
                    ]

        1 ->
            [ List.repeat 2 (EntityBlock (Enemy Golem))
            , List.repeat 1 (EntityBlock Crate)
            , List.repeat 1 (ItemBlock Heart)
            ]
                |> List.concat
                |> Game.Build.generator
                    [ "⬜⬜⬜⬜⬜"
                    , "⬜📦❌⬜⬜"
                    , "⬜❌📦❌⬜"
                    , "⬜⬜❌⬜⬜"
                    , "⬜⬜😊⬜⬜"
                    ]

        2 ->
            [ List.repeat 3 (EntityBlock (Enemy Golem))
            , List.repeat 2 (EntityBlock Crate)
            , List.repeat 1 (ItemBlock Heart)
            , List.repeat 1 (ItemBlock InactiveBomb)
            ]
                |> List.concat
                |> Game.Build.generator
                    [ "📦⬜⬜⬜📦"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜💣⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "📦⬜😊⬜📦"
                    ]

        3 ->
            [ List.repeat 1 (EntityBlock (Enemy Golem))
            , List.repeat 1 (ItemBlock InactiveBomb)
            ]
                |> List.concat
                |> Game.Build.generator
                    [ "⬜⬜⬜⬜⬜"
                    , "⬜⬜📦⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜😊⬜⬜"
                    ]

        _ ->
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
                             , List.repeat 3 (ItemBlock InactiveBomb)
                             , List.repeat 3 (EntityBlock Crate)
                             , List.repeat 1 (ItemBlock Heart)
                             , List.repeat 1 HoleBlock
                             ]
                                |> List.concat
                            )
                            [ [ List.repeat 1 (Enemy Golem |> EntityBlock)
                              , List.repeat 1 (Enemy (Goblin Down) |> EntityBlock)
                              , List.repeat 1 (Enemy (Goblin Left) |> EntityBlock)
                              , List.repeat 3 (ItemBlock InactiveBomb)
                              , List.repeat 3 (EntityBlock Crate)
                              , List.repeat 1 (ItemBlock Heart)
                              , List.repeat 1 HoleBlock
                              ]
                                |> List.concat
                            , [ List.repeat 1 (Enemy Golem |> EntityBlock)
                              , List.repeat 2 (Enemy Rat |> EntityBlock)
                              , List.repeat 3 (ItemBlock InactiveBomb)
                              , List.repeat 3 (EntityBlock Crate)
                              , List.repeat 1 (ItemBlock Heart)
                              , List.repeat 1 HoleBlock
                              ]
                                |> List.concat
                            ]
                            |> Random.andThen (Game.Build.generator layout)
                    )


goblinDungeon : Int -> Generator Game
goblinDungeon stage =
    case stage // Config.stageRepetition of
        0 ->
            [ List.repeat 1 (EntityBlock (Enemy (Goblin Left)))
            , List.repeat 1 HoleBlock
            ]
                |> List.concat
                |> Game.Build.generator
                    [ "❌⬜💚⬜❌"
                    , "❌⬜⬜⬜❌"
                    , "❌⬜⬜⬜❌"
                    , "❌⬜⬜⬜❌"
                    , "❌⬜😊⬜❌"
                    ]

        1 ->
            [ List.repeat 1 (EntityBlock (Enemy (Goblin Down)))
            , List.repeat 1 (EntityBlock (Enemy (Goblin Up)))
            , List.repeat 1 HoleBlock
            , List.repeat 1 (ItemBlock Heart)
            ]
                |> List.concat
                |> Game.Build.generator
                    [ "❌❌❌❌❌"
                    , "❌⬜📦⬜❌"
                    , "❌⬜⬜⬜❌"
                    , "❌⬜⬜⬜❌"
                    , "❌⬜😊⬜❌"
                    ]

        2 ->
            [ List.repeat 1 (EntityBlock (Enemy (Goblin Right)))
            , List.repeat 1 (EntityBlock (Enemy (Goblin Left)))
            , List.repeat 1 (EntityBlock (Enemy (Goblin Down)))
            , List.repeat 2 HoleBlock
            ]
                |> List.concat
                |> Game.Build.generator
                    [ "❌❌❌❌❌"
                    , "⬜⬜📦⬜⬜"
                    , "⬜⬜💚⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜😊⬜⬜"
                    ]

        3 ->
            holeChallenge

        _ ->
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
                             , List.repeat 2 (ItemBlock InactiveBomb)
                             , List.repeat 2 (EntityBlock Crate)
                             , List.repeat 1 (ItemBlock Heart)
                             ]
                                |> List.concat
                            )
                            [ [ List.repeat 1 (EntityBlock (Enemy (Goblin Right)))
                              , List.repeat 1 (EntityBlock (Enemy (Goblin Left)))
                              , List.repeat 2 (ItemBlock InactiveBomb)
                              , List.repeat 3 (EntityBlock Crate)
                              , List.repeat 1 (ItemBlock Heart)
                              ]
                                |> List.concat
                            , [ List.repeat 1 (EntityBlock (Enemy (Goblin Down)))
                              , List.repeat 1 (EntityBlock (Enemy Rat))
                              , List.repeat 2 (ItemBlock InactiveBomb)
                              , List.repeat 3 (EntityBlock Crate)
                              , List.repeat 1 (ItemBlock Heart)
                              ]
                                |> List.concat
                            ]
                            |> Random.andThen (Game.Build.generator layout)
                    )


holeChallenge : Generator Game
holeChallenge =
    [ List.repeat 1 (EntityBlock (Enemy (Goblin Left)))
    , List.repeat 1 (EntityBlock (Enemy (Goblin Down)))
    , List.repeat 1 (EntityBlock Crate)
    , List.repeat 2 (ItemBlock Heart)
    ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜📦⬜⬜⬜"
            , "⬜⬜❌⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]


tutorialDungeon : Int -> Generator Game
tutorialDungeon stage =
    case stage // Config.stageRepetition of
        0 ->
            World.Trial.fromInt 0
                |> Maybe.withDefault empty

        1 ->
            World.Trial.fromInt 1
                |> Maybe.withDefault empty

        2 ->
            World.Trial.fromInt 2
                |> Maybe.withDefault empty

        3 ->
            World.Trial.fromInt 3
                |> Maybe.withDefault empty

        _ ->
            Random.uniform
                [ "💣⬜⬜⬜💣"
                , "⬜⬜⬜⬜⬜"
                , "⬜⬜⬜⬜⬜"
                , "⬜⬜⬜⬜⬜"
                , "💣⬜😊⬜💣"
                ]
                [ [ "📦⬜⬜⬜📦"
                  , "⬜⬜⬜⬜⬜"
                  , "⬜⬜⬜⬜⬜"
                  , "⬜⬜⬜⬜⬜"
                  , "📦⬜😊⬜📦"
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
                            ([ List.repeat 3 (Enemy Rat |> EntityBlock)
                             , List.repeat 4 (ItemBlock InactiveBomb)
                             , List.repeat 2 (EntityBlock Crate)
                             , List.repeat 1 (ItemBlock Heart)
                             ]
                                |> List.concat
                            )
                            [ [ List.repeat 3 (Enemy Rat |> EntityBlock)
                              , List.repeat 2 (ItemBlock InactiveBomb)
                              , List.repeat 4 (EntityBlock Crate)
                              , List.repeat 1 (ItemBlock Heart)
                              ]
                                |> List.concat
                            , [ List.repeat 2 (Enemy Rat |> EntityBlock)
                              , List.repeat 1 (Enemy (Goblin Down) |> EntityBlock)
                              , List.repeat 3 (ItemBlock InactiveBomb)
                              , List.repeat 3 (EntityBlock Crate)
                              , List.repeat 1 (ItemBlock Heart)
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
    , List.repeat 4 (ItemBlock InactiveBomb)
    , [ ItemBlock Heart
      , HoleBlock
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
      , ItemBlock Heart
      , HoleBlock
      ]
    , List.repeat 4 (ItemBlock InactiveBomb)
    ]
        |> List.concat


golemLevel : List BuildingBlock
golemLevel =
    [ List.repeat 3 (EntityBlock (Enemy Golem))
    , List.repeat 3 (ItemBlock InactiveBomb)
    , List.repeat 3 (EntityBlock Crate)
    , [ ItemBlock Heart
      , HoleBlock
      ]
    ]
        |> List.concat


finalLevel : List BuildingBlock
finalLevel =
    [ List.repeat 3 (ItemBlock InactiveBomb)
    , List.repeat 3 (EntityBlock Crate)
    , [ ItemBlock Heart
      , EntityBlock (Enemy Rat)
      , Enemy (Goblin Left) |> EntityBlock
      , EntityBlock (Enemy Golem)
      , HoleBlock
      ]
    ]
        |> List.concat
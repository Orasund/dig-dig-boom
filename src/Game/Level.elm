module Game.Level exposing (..)

import Config
import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Game)
import Game.Build exposing (BuildingBlock(..))
import Position
import Random exposing (Generator)


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


toGame : List String -> List BuildingBlock -> Generator Game
toGame emojis blocks =
    let
        dict =
            Game.Build.fromEmojis emojis

        rec () =
            Position.asGrid
                { columns = Config.mapSize
                , rows = Config.mapSize
                }
                |> List.filter
                    (\pos ->
                        Dict.member pos dict |> not
                    )
                |> shuffle
                |> Random.map
                    (\list ->
                        List.map2 Tuple.pair list blocks
                            ++ Dict.toList dict
                    )
                |> Random.map Game.Build.fromBlocks
                |> Random.andThen
                    (\game ->
                        if validator game.cells then
                            Random.constant game

                        else
                            Random.lazy rec
                    )
    in
    rec ()


generate : Level -> Generator Game
generate level =
    case level.dungeon of
        0 ->
            tutorialDungeon level.stage

        _ ->
            Random.map2 toGame
                randomLayout
                (Random.uniform
                    golemLevel
                    []
                 {--[ ratLevel
                , goblinLevel
                , finalLevel
                ]--}
                )
                |> Random.andThen identity


tutorialDungeon : Int -> Generator Game
tutorialDungeon stage =
    case stage of
        0 ->
            [ List.repeat 1 (EntityBlock (Enemy Rat))
            , List.repeat 2 (ItemBlock InactiveBomb)
            , List.repeat 1 (ItemBlock Heart)
            ]
                |> List.concat
                |> toGame
                    [ "💣⬜⬜⬜💣"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "💣⬜😊⬜💣"
                    ]

        1 ->
            [ List.repeat 2 (EntityBlock (Enemy Rat))
            , List.repeat 5 (ItemBlock InactiveBomb)
            , List.repeat 3 (EntityBlock Crate)
            ]
                |> List.concat
                |> toGame
                    [ "📦⬜⬜⬜📦"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "📦⬜😊⬜📦"
                    ]

        2 ->
            [ List.repeat 3 (EntityBlock (Enemy Rat))
            , List.repeat 3 (ItemBlock InactiveBomb)
            , List.repeat 2 (EntityBlock Crate)
            , List.repeat 1 (ItemBlock Heart)
            ]
                |> List.concat
                |> toGame
                    [ "📦⬜⬜⬜💣"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "⬜⬜⬜⬜⬜"
                    , "💣⬜😊⬜📦"
                    ]

        3 ->
            ratChallenge

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
                            |> Random.andThen (toGame layout)
                    )


ratChallenge : Generator Game
ratChallenge =
    [ List.repeat 2 (EntityBlock (Enemy Rat))
    , List.repeat 2 (ItemBlock InactiveBomb)
    , List.repeat 1 (ItemBlock Heart)
    ]
        |> List.concat
        |> toGame
            [ "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜📦⬜📦⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]


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


validator =
    \dict ->
        dict
            |> Dict.toList
            |> List.all
                (\( pos, cell ) ->
                    case cell.entity of
                        Enemy _ ->
                            Game.Build.neighbors4 pos dict
                                |> List.all
                                    (\c ->
                                        case c of
                                            Just (Enemy _) ->
                                                False

                                            _ ->
                                                True
                                    )

                        Player ->
                            (Game.Build.count ((==) Nothing)
                                (Game.Build.neighbors4 pos dict)
                                > 1
                            )
                                && (Game.Build.diagNeighbors pos dict
                                        |> List.all
                                            (\c ->
                                                case c of
                                                    Just (Enemy _) ->
                                                        False

                                                    _ ->
                                                        True
                                            )
                                   )

                        Crate ->
                            Game.Build.count ((==) (Just Crate))
                                (Game.Build.neighbors4 pos dict)
                                < 1

                        _ ->
                            True
                )


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

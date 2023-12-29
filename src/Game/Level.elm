module Game.Level exposing (..)

import Config
import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Game)
import Game.Build exposing (BuildingBlock(..))
import Position
import Random exposing (Generator)


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


generate : Generator Game
generate =
    Random.uniform
        golemLevel
        []
        {--[ ratLevel
        , goblinLevel
        , finalLevel
        ]--}
        |> Random.andThen identity


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
          , "⬜⬜😊⬜⬜"
          ]
        , [ "❌⬜⬜⬜❌"
          , "❌⬜⬜⬜❌"
          , "❌⬜⬜⬜❌"
          , "❌⬜⬜⬜❌"
          , "❌⬜😊⬜❌"
          ]
        , [ "⬜⬜⬜⬜⬜"
          , "⬜⬜❌⬜⬜"
          , "⬜❌⬜❌⬜"
          , "⬜⬜❌⬜⬜"
          , "⬜⬜😊⬜⬜"
          ]
        , [ "⬜❌⬜❌⬜"
          , "❌⬜⬜⬜❌"
          , "⬜⬜📦⬜⬜"
          , "❌⬜⬜⬜❌"
          , "⬜❌😊❌⬜"
          ]
        , [ "📦⬜⬜⬜📦"
          , "📦⬜⬜⬜📦"
          , "📦⬜⬜⬜📦"
          , "📦⬜⬜⬜📦"
          , "📦⬜😊⬜📦"
          ]
        ]


ratLevel : Generator Game
ratLevel =
    randomLayout
        |> Random.andThen
            (\layout ->
                [ List.repeat 4 (EntityBlock (Enemy Rat))
                , List.repeat 3 (EntityBlock Crate)
                , List.repeat 4 (ItemBlock InactiveBomb)
                , [ ItemBlock Heart
                  , HoleBlock
                  ]
                ]
                    |> List.concat
                    |> toGame layout
            )


goblinLevel : Generator Game
goblinLevel =
    randomLayout
        |> Random.andThen
            (\layout ->
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
                    |> toGame layout
            )


emptyLevel : Generator Game
emptyLevel =
    randomLayout
        |> Random.andThen (\layout -> toGame layout [])


golemLevel : Generator Game
golemLevel =
    randomLayout
        |> Random.andThen
            (\layout ->
                [ List.repeat 3 (EntityBlock (Enemy Golem))
                , List.repeat 3 (ItemBlock InactiveBomb)
                , List.repeat 3 (EntityBlock Crate)
                , [ ItemBlock Heart
                  , HoleBlock
                  ]
                ]
                    |> List.concat
                    |> toGame layout
            )


finalLevel : Generator Game
finalLevel =
    randomLayout
        |> Random.andThen
            (\layout ->
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
                    |> toGame layout
            )


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

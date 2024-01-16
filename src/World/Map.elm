module World.Map exposing (..)

import Config
import Dict exposing (Dict)
import Entity exposing (Entity(..))
import Game exposing (Game)
import Game.Build exposing (BuildingBlock(..))


get : ( Int, Int ) -> Game
get pos =
    dict
        |> Dict.get pos
        |> Maybe.withDefault Dict.empty
        |> Dict.toList
        |> Game.Build.fromBlocks
            { doors =
                getDoors pos
            }


getDoors : ( Int, Int ) -> List ( ( Int, Int ), { room : ( Int, Int ) } )
getDoors ( x, y ) =
    [ ( ( x - 1, y ), ( -1, 2 ) )
    , ( ( x, y - 1 ), ( 2, -1 ) )
    , ( ( x + 1, y ), ( Config.roomSize, 2 ) )
    , ( ( x, y + 1 ), ( 2, Config.roomSize ) )
    ]
        |> List.filterMap
            (\( room, pos ) ->
                if dict |> Dict.member room then
                    Just ( pos, { room = room } )

                else
                    Nothing
            )


dict : Dict ( Int, Int ) (Dict ( Int, Int ) BuildingBlock)
dict =
    sokoBombLevels ( 0, 0 )
        ++ lavaLevels
        ++ [ ( ( -1, -12 )
             , [ "❌❌⬜⬜⬜"
               , "❌❌⬜❌⬜"
               , "⬜❌⬜❌⬜"
               , "⬜❌⬜❌❌"
               , "⬜⬜⬜❌❌"
               ]
                |> Game.Build.fromEmojis
             )
           , ( ( -1, -5 )
             , [ "🧱🧱🧱🧱🧱"
               , "⬜⬜⬜❌⬜"
               , "⬜🔑📦❌⬜"
               , "⬜⬜⬜❌⬜"
               , "🧱🧱🧱🧱🧱"
               ]
                |> Game.Build.fromEmojis
             )
           , ( ( 1, -5 )
             , [ "🧊🧊🧊🧱🧱"
               , "🧊🧱🧊🧱⬜"
               , "⬜🧱🧊🧱⬜"
               , "⬜🧱🧊🧱🧊"
               , "🧱🧱🧊🧊🧊"
               ]
                |> Game.Build.fromEmojis
             )
           , ( ( 2, -5 )
             , [ "🧊🧊⬜🧊🧊"
               , "🧊🧊🧊🧊🧊"
               , "⬜🧊🧊🧊⬜"
               , "🧊🧊🧊🧊🧊"
               , "🧊🧊⬜🧊🧊"
               ]
                |> Game.Build.fromEmojis
             )
           , ( ( 2, -6 )
             , [ "🧊🧱🧊🧱🧊"
               , "🧊🧊⬜🧊🧊"
               , "⬜🧊🧱🧊⬜"
               , "⬜🧊⬜🧊⬜"
               , "🧊🧊🧊🧊🧊"
               ]
                |> Game.Build.fromEmojis
             )
           , ( ( 2, -7 )
             , [ "🧊🧊🧊🧊🧊"
               , "🧊🧊🧊🧱🧊"
               , "🧱🧊🧊🧊🧊"
               , "🧊🧊🧱🧊🧊"
               , "🧊🧊🧊🧊🧱"
               ]
                |> Game.Build.fromEmojis
             )
           , ( ( 2, -8 )
             , [ "🧊🧊🧊🧊🧊"
               , "🧊🧊🧊🧊🧊"
               , "🧊🧊📦🧊🧊"
               , "🧊🧊🧊🧊🧊"
               , "🧊🧊🧊🧊🧊"
               ]
                |> Game.Build.fromEmojis
             )
           , ( ( 2, -9 )
             , [ "🧊🧊🧊🧊🧊"
               , "🧊🧊🧱🧊🧊"
               , "🧊🧊📦🧊🧊"
               , "📦🧊🧊🧊📦"
               , "🧊🧊🧊🧊🧊"
               ]
                |> Game.Build.fromEmojis
             )
           , ( ( 2, -10 )
             , [ "🧊🧊🧊🧊🧊"
               , "🧊🧊📦🧊🧊"
               , "🧊🧊📦🧊🧊"
               , "🧊📦🧊📦🧊"
               , "🧊🧊🧊🧊🧊"
               ]
                |> Game.Build.fromEmojis
             )
           , ( ( 2, -11 )
             , [ "🧱🧱🧱🧱🧱"
               , "⬜⬜⬜⬜⬜"
               , "⬜⬜💎⬜⬜"
               , "⬜⬜⬜⬜⬜"
               , "⬜⬜⬜⬜⬜"
               ]
                |> Game.Build.fromEmojis
             )
           ]
        |> Dict.fromList


lavaLevels : List ( ( Int, Int ), Dict ( Int, Int ) BuildingBlock )
lavaLevels =
    [ ( ( -2, -12 )
      , [ "❌❌❌❌❌"
        , "❌⬜⬜⬜⬜"
        , "❌⬜📦⬜⬜"
        , "❌❌❌❌❌"
        , "❌⬜⬜⬜❌"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( -2, -11 )
      , [ "⬜⬜⬜⬜⬜"
        , "⬜⬜📦⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "❌❌❌❌❌"
        , "⬜⬜📦⬜⬜"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( -2, -10 )
      , [ "⬜⬜⬜⬜⬜"
        , "⬜📦📦📦⬜"
        , "❌❌📦❌❌"
        , "❌❌❌❌❌"
        , "❌❌📦❌❌"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( -2, -9 )
      , [ "⬜⬜⬜⬜⬜"
        , "📦📦📦📦📦"
        , "⬜📦⬜📦⬜"
        , "❌❌🧱❌❌"
        , "❌❌❌❌❌"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( -2, -8 )
      , [ "⬜⬜⬜⬜⬜"
        , "⬜⬜📦⬜⬜"
        , "⬜📦🧨📦⬜"
        , "❌❌❌❌❌"
        , "🧱🧱🧱🧱🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( -2, -7 )
      , [ "⬜⬜⬜⬜⬜"
        , "⬜📦🧨📦⬜"
        , "❌🧨📦🧨❌"
        , "❌🧱🧱🧱❌"
        , "❌❌❌❌❌"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( -2, -6 )
      , [ "❌🧨⬜🧨❌"
        , "❌📦📦📦❌"
        , "❌🧨📦🧨❌"
        , "❌❌🧱❌❌"
        , "❌❌⬜❌❌"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( -2, -5 )
      , [ "⬜⬜⬜❌❌"
        , "⬜🧨⬜❌❌"
        , "⬜⬜⬜❌❌"
        , "📦📦📦❌❌"
        , "⬜⬜⬜❌❌"
        ]
            |> Game.Build.fromEmojis
      )
    ]


sokoBombLevels : ( Int, Int ) -> List ( ( Int, Int ), Dict ( Int, Int ) BuildingBlock )
sokoBombLevels ( x, y ) =
    [ ( ( x, y )
      , [ "🧱📦⬜📦🧱"
        , "🧱⬜📦⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 1 )
      , [ "🧱📦⬜📦🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱📦📦📦🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 2 )
      , [ "🧱⬜📦⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱📦⬜📦🧱"
        , "🧱⬜📦⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 3 )
      , [ "🧱📦📦📦🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜🧨⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 4 )
      , [ "🧱⬜📦⬜🧱"
        , "🧱📦📦📦🧱"
        , "🧱⬜🧨⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 5 )
      , [ "🧱📦📦📦🧱"
        , "🧱📦🧨📦🧱"
        , "🧱⬜🧨⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
            |> Dict.insert ( Config.roomSize, 2 ) (EntityBlock LockedDoor)
      )
    , ( ( x, y - 6 )
      , [ "🧱🧱🧱🧱🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜🧨⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 7 )
      , [ "🧱🧱🧱🧱🧱"
        , "🧱📦📦📦🧱"
        , "🧱🧨🧨🧨🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 8 )
      , [ "🧱🧱🧱🧱🧱"
        , "🧱🧨📦🧨🧱"
        , "🧱📦🧨📦🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 9 )
      , [ "🧱⬜📦⬜🧱"
        , "🧨⬜⬜⬜🧨"
        , "🧱📦📦📦🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 10 )
      , [ "🧱⬜📦⬜🧱"
        , "🧱📦⬜📦🧱"
        , "🧨⬜📦⬜🧨"
        , "🧨📦📦📦🧨"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 11 )
      , [ "🧱⬜🧱⬜🧱"
        , "🧨🧱📦🧱🧨"
        , "🧨📦🧨📦🧨"
        , "🧨⬜🧨⬜🧨"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 12 )
      , [ "🧱🧱🧱🧱🧱"
        , "🧱⬜🧨⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
            |> Dict.insert ( -1, 2 ) (EntityBlock LockedDoor)
      )
    , ( ( x, y - 13 )
      , [ "🧱🧱🧱🧱🧱"
        , "🧱🧱🧱🧱🧱"
        , "🧱⬜🔑⬜🧱"
        , "🧱⬜⬜⬜🧱"
        , "🧱⬜😊⬜🧱"
        ]
            |> Game.Build.fromEmojis
      )
    ]


icePuzzles =
    [ [ "🧊🧱🧊🧊🧊"
      , "🧊🧊🧊🧊🧊"
      , "🧊🧊🧊🧊🧊"
      , "🧊🧊🧱🧊🧊"
      , "🧊🧊🧊🧊🧊"
      ]
    , [ "🧊🧊🧊🧊🧱"
      , "🧊🧱🧊🧊🧊"
      , "🧊🧊🧊🧊🧊"
      , "🧊🧊🧱🧊🧊"
      , "🧊🧊🧊🧊🧊"
      ]
    , [ "🧊🧊🧊🧊🧊"
      , "🧊🧱🧊🧊🧊"
      , "🧊🧊🧊🧊🧱"
      , "🧊🧊🧱🧊🧊"
      , "🧊🧊🧊🧊🧊"
      ]
    , [ "🧊🧊🧊🧊🧊"
      , "🧊🧊🧊🧊🧱"
      , "🧊🧱🧊🧊🧊"
      , "🧊🧊🧱🧊🧊"
      , "🧊🧊🧊🧊🧊"
      ]
    , [ "🧊🧊🧊🧊🧊"
      , "🧊🧊🧊🧱🧊"
      , "🧊🧱🧊🧊🧊"
      , "🧊🧊🧱🧊🧊"
      , "🧊🧊🧊🧊🧱"
      ]
    ]

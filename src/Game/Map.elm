module Game.Map exposing (..)

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
    [ ( ( 0, 0 )
      , [ "🧱🧱⬜🧱🧱"
        , "🧱🧱⬜⬜🧱"
        , "🧱⬜⬜⬜⬜"
        , "🧱⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        ]
            |> Game.Build.fromEmojis
            |> Dict.insert ( Config.roomSize, 2 ) (EntityBlock LockedDoor)
      )
    , ( ( 1, 0 )
      , [ "🧱🧱🧱🧱🧱"
        , "🧱🧱⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜❌❌"
        , "❌❌❌❌❌"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( 2, 0 )
      , [ "🧱⬜⬜❌❌"
        , "⬜⬜⬜❌❌"
        , "⬜⬜⬜⬜⬜"
        , "❌⬜⬜❌❌"
        , "❌❌❌❌❌"
        ]
            |> Game.Build.fromEmojis
            |> Dict.insert ( Config.roomSize, 2 ) (EntityBlock LockedDoor)
      )
    , ( ( 3, 0 )
      , [ "❌❌⬜🧊🧊"
        , "❌❌⬜⬜🧊"
        , "⬜⬜⬜⬜⬜"
        , "❌❌🧊⬜⬜"
        , "❌❌❌🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( 4, 0 )
      , [ "🧊🧊⬜⬜🧊"
        , "🧊🧊⬜⬜🧊"
        , "⬜⬜⬜🧊🧊"
        , "⬜⬜🧊🧊🧊"
        , "🧊🧊🧊🧊🧊"
        ]
            |> Game.Build.fromEmojis
            |> Dict.insert ( Config.roomSize, 2 ) (EntityBlock LockedDoor)
      )
    , ( ( 5, 0 )
      , [ "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜💎⬜⬜"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        ]
            |> Game.Build.fromEmojis
      )
    ]
        ++ sokoBombLevels ( 0, -1 )
        ++ lavaLevels ( 2, -1 )
        ++ iceLevels ( 4, -1 )
        |> Dict.fromList


iceLevels : ( Int, Int ) -> List ( ( Int, Int ), Dict ( Int, Int ) BuildingBlock )
iceLevels ( x, y ) =
    [ ( ( x, y )
      , [ "🧱🧱🧊🧊🧊"
        , "🧱🧱🧱🧱🧊"
        , "🧊🧊🧊🧊🧊"
        , "🧊🧱🧱🧱🧱"
        , "🧊🧊🧊🧱🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 1 )
      , [ "🧊🧊⬜🧊🧊"
        , "🧊🧊🧊🧊🧊"
        , "⬜🧊🧊🧊⬜"
        , "🧊🧊🧊🧊🧊"
        , "🧊🧊⬜🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 2 )
      , [ "🧊🧱🧊🧱🧊"
        , "🧊🧊⬜🧊🧊"
        , "⬜🧊🧱🧊⬜"
        , "⬜🧊⬜🧊⬜"
        , "🧊🧊🧊🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 3 )
      , [ "🧊🧊🧊🧊🧊"
        , "🧊🧊🧊🧱🧊"
        , "🧱🧊🧊🧊🧊"
        , "🧊🧊🧱🧊🧊"
        , "🧊🧱🧊🧊🧱"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 4 )
      , [ "🧊🧊🧊🧊🧊"
        , "🧊🧊🧊🧊🧊"
        , "🧊🧊📦🧊🧊"
        , "🧊🧊🧊🧊🧊"
        , "🧊🧊🧊🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 5 )
      , [ "🧊🧊🧊🧊🧊"
        , "🧊🧊🧱🧊🧊"
        , "📦🧊📦🧊📦"
        , "🧊🧊🧊🧊🧊"
        , "🧊🧊🧊🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 6 )
      , [ "📦🧊🧊🧊📦"
        , "🧊🧊🧊🧊🧊"
        , "🧊🧱📦🧱🧊"
        , "🧊📦🧊📦🧊"
        , "🧊🧊🧊🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 7 )
      , [ "🧊🧊🧱🧊🧊"
        , "🧊🧊🧊🧊🧊"
        , "🧊🧨🧊🧨🧊"
        , "🧊🧊🧊🧊🧊"
        , "🧊🧊🧊🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 8 )
      , [ "🧊🧊🧱🧊🧊"
        , "🧊🧊📦🧊🧊"
        , "🧊📦🧨📦🧊"
        , "🧊🧊🧊🧊🧊"
        , "🧊🧊🧊🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 9 )
      , [ "🧊🧊🧱🧊🧊"
        , "🧊📦🧊📦🧊"
        , "🧊🧊🧨🧊🧊"
        , "🧊📦🧨📦🧊"
        , "🧊🧊🧊🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 10 )
      , [ "🧊🧊⬜🧊🧊"
        , "🧊⬜🧊⬜🧊"
        , "🧊🔑🧊🧊⬜"
        , "🧊⬜🧊⬜🧊"
        , "🧊🧊🧊🧊🧊"
        ]
            |> Game.Build.fromEmojis
      )
    ]


lavaLevels : ( Int, Int ) -> List ( ( Int, Int ), Dict ( Int, Int ) BuildingBlock )
lavaLevels ( x, y ) =
    [ ( ( x, y )
      , [ "⬜⬜⬜❌❌"
        , "⬜⬜❌❌❌"
        , "⬜⬜📦⬜⬜"
        , "❌❌❌⬜⬜"
        , "❌⬜⬜⬜⬜"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 1 )
      , [ "❌⬜⬜⬜❌"
        , "❌⬜📦⬜❌"
        , "❌❌❌❌❌"
        , "❌⬜📦⬜❌"
        , "❌⬜⬜⬜❌"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 2 )
      , [ "⬜⬜⬜⬜⬜"
        , "❌📦❌📦❌"
        , "❌❌❌❌❌"
        , "⬜📦📦📦⬜"
        , "⬜⬜⬜⬜⬜"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 3 )
      , [ "❌⬜❌⬜❌"
        , "❌⬜❌⬜❌"
        , "📦📦🧱📦📦"
        , "⬜⬜⬜⬜⬜"
        , "⬜⬜⬜⬜⬜"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 4 )
      , [ "❌📦❌📦❌"
        , "🧨🧱🧱🧱🧨"
        , "🧱❌📦❌🧱"
        , "⬜📦🧨📦⬜"
        , "⬜⬜⬜⬜⬜"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 5 )
      , [ "⬜⬜❌⬜⬜"
        , "📦🧱🧱🧱📦"
        , "❌🧨📦🧨❌"
        , "❌📦🧨📦❌"
        , "❌⬜⬜⬜❌"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 6 )
      , [ "❌❌❌📦❌"
        , "❌❌❌❌📦"
        , "⬜📦⬜⬜❌"
        , "⬜📦⬜🧨⬜"
        , "⬜📦⬜⬜⬜"
        ]
            |> Game.Build.fromEmojis
      )
    , ( ( x, y - 7 )
      , [ "⬜⬜⬜⬜⬜"
        , "⬜❌⬜❌⬜"
        , "⬜❌🔑❌⬜"
        , "⬜❌❌❌⬜"
        , "⬜⬜⬜⬜⬜"
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
        , "🧨📦⬜📦🧨"
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
      )
    , ( ( x, y - 13 )
      , [ "⬜⬜⬜⬜⬜"
        , "⬜🧱⬜🧱⬜"
        , "⬜🧱🔑🧱⬜"
        , "⬜🧱🧱🧱⬜"
        , "⬜⬜⬜⬜⬜"
        ]
            |> Game.Build.fromEmojis
      )
    ]

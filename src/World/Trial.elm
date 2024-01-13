module World.Trial exposing (..)

import Array exposing (Array)
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Game)
import Game.Build exposing (BuildingBlock(..))
import Random exposing (Generator)


fromInt : Int -> Maybe (Generator Game)
fromInt i =
    Array.get i asArray


asArray : Array (Generator Game)
asArray =
    []
        {--++ lavaTrails
        ++ ratTrails
        ++ goblinTrails
        ++ golemTrail--}
        |> Array.fromList


bombTrails : List (Generator Game)
bombTrails =
    [ Game.Build.generator
        [ "📦⬜📦📦📦"
        , "📦💣📦📦⬜"
        , "📦📦⬜⬜📦"
        , "⬜⬜💣⬜⬜"
        , "⬜⬜😊⬜⬜"
        ]
        []
    , Game.Build.generator
        [ "📦📦📦⬜📦"
        , "📦⬜📦📦⬜"
        , "📦💣💣⬜📦"
        , "⬜⬜📦📦⬜"
        , "⬜⬜😊⬜📦"
        ]
        []
    , Game.Build.generator
        [ "📦⬜📦📦📦"
        , "📦⬜⬜📦⬜"
        , "⬜⬜📦⬜⬜"
        , "⬜💣📦📦📦"
        , "⬜📦😊📦⬜"
        ]
        []
    , Game.Build.generator
        [ "⬜⬜📦💣📦"
        , "⬜⬜📦⬜⬜"
        , "⬜📦⬜📦📦"
        , "📦📦📦⬜⬜"
        , "📦⬜😊💣⬜"
        ]
        []
    , Game.Build.generator
        [ "📦📦💣📦📦"
        , "📦📦📦📦📦"
        , "📦⬜⬜💣⬜"
        , "⬜📦⬜⬜⬜"
        , "⬜⬜😊⬜⬜"
        ]
        []
    , Game.Build.generator
        [ "📦📦📦⬜📦"
        , "📦⬜💣📦⬜"
        , "⬜💣📦📦⬜"
        , "⬜⬜📦⬜📦"
        , "⬜⬜😊⬜📦"
        ]
        []
    , Game.Build.generator
        [ "⬜📦📦📦⬜"
        , "⬜💣⬜⬜💣"
        , "📦📦📦📦💣"
        , "📦💣💣⬜💣"
        , "⬜💣😊💣⬜"
        ]
        []
    ]


lavaTrails : List (Generator Game)
lavaTrails =
    [ []
        |> List.concat
        |> Game.Build.generator
            [ "❌❌📦⬜❌"
            , "❌❌❌⬜❌"
            , "❌📦⬜📦❌"
            , "❌⬜❌❌❌"
            , "❌📦😊⬜⬜"
            ]
    , Game.Build.generator
        [ "❌❌📦❌❌"
        , "❌⬜⬜📦❌"
        , "❌⬜📦⬜❌"
        , "❌📦⬜⬜❌"
        , "❌⬜😊⬜❌"
        ]
        []
    ]


ratTrails : List (Generator Game)
ratTrails =
    [ []
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜⬜📦⬜⬜"
            , "⬜📦🐀📦⬜"
            , "⬜⬜📦⬜⬜"
            , "💣⬜😊⬜💣"
            ]
    , []
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜⬜⬜🐀"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "💣⬜😊⬜⬜"
            ]
    ]


goblinTrails : List (Generator Game)
goblinTrails =
    [ [ List.repeat 1 (EntityBlock (Enemy (Orc Down)))
      ]
        |> List.concat
        |> Game.Build.generator
            [ "❌❌⬜❌❌"
            , "❌❌⬜❌❌"
            , "❌❌⬜❌❌"
            , "❌❌💣❌❌"
            , "❌❌😊❌❌"
            ]
    , [ List.repeat 1 (EntityBlock (Enemy (Orc Left)))
      , List.repeat 1 (EntityBlock (Enemy (Orc Down)))
      , List.repeat 1 (EntityBlock Crate)
      , List.repeat 2 (ItemBlock Bomb)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜📦⬜⬜⬜"
            , "⬜⬜❌⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    ]


golemTrail : List (Generator Game)
golemTrail =
    [ [ List.repeat 1 (EntityBlock (Enemy Doppelganger))
      , List.repeat 1 (EntityBlock Crate)
      , List.repeat 1 (ItemBlock Bomb)
      , List.repeat 1 HoleBlock
      ]
        |> List.concat
        |> Game.Build.generator
            [ "❌⬜⬜⬜❌"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜💣⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "❌⬜😊⬜❌"
            ]
    , [ List.repeat 2 (EntityBlock (Enemy Doppelganger))
      , List.repeat 1 (EntityBlock Crate)
      , List.repeat 1 (ItemBlock Bomb)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜📦❌⬜⬜"
            , "⬜❌📦❌⬜"
            , "⬜⬜❌⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    , [ List.repeat 3 (EntityBlock (Enemy Doppelganger))
      , List.repeat 2 (EntityBlock Crate)
      , List.repeat 2 (ItemBlock Bomb)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "📦⬜⬜⬜📦"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜💣⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "📦⬜😊⬜📦"
            ]
    , [ List.repeat 1 (EntityBlock (Enemy Doppelganger))
      , List.repeat 1 (ItemBlock Bomb)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜⬜📦⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    ]

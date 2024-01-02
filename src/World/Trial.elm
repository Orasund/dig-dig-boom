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
    crateTails
        ++ ratTrails
        ++ goblinTrails
        ++ golemTrail
        |> Array.fromList


crateTails : List (Generator Game)
crateTails =
    [ [ List.repeat 1 (ItemBlock Bomb) ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜📦⬜📦⬜"
            , "⬜⬜📦⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    , [ List.repeat 2 (ItemBlock Bomb) ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜📦⬜📦⬜"
            , "📦⬜📦⬜📦"
            , "⬜📦⬜📦⬜"
            , "📦⬜📦⬜📦"
            , "⬜⬜😊⬜⬜"
            ]
    , [ List.repeat 2 (ItemBlock Bomb) ]
        |> List.concat
        |> Game.Build.generator
            [ "❌❌📦❌❌"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    , [ List.repeat 1 (ItemBlock Bomb) ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜❌⬜⬜"
            , "⬜⬜📦⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    , [ List.repeat 2 (ItemBlock Bomb) ]
        |> List.concat
        |> Game.Build.generator
            [ "❌❌📦⬜❌"
            , "❌❌❌⬜❌"
            , "❌📦⬜📦❌"
            , "❌⬜❌❌❌"
            , "❌📦😊⬜⬜"
            ]
    ]


ratTrails : List (Generator Game)
ratTrails =
    [ [ List.repeat 1 (EntityBlock (Enemy Rat))
      , List.repeat 1 (ItemBlock Bomb)
      , List.repeat 1 (ItemBlock CrossBomb)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    , [ List.repeat 2 (EntityBlock (Enemy Rat))
      , List.repeat 1 (ItemBlock Bomb)
      , List.repeat 1 (ItemBlock CrossBomb)
      , List.repeat 1 (EntityBlock Crate)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    , [ List.repeat 2 (EntityBlock (Enemy Rat))
      , List.repeat 5 (ItemBlock Bomb)
      , List.repeat 4 (EntityBlock Crate)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "📦⬜⬜⬜📦"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "📦⬜😊⬜📦"
            ]
    , [ List.repeat 3 (EntityBlock (Enemy Rat))
      , List.repeat 4 (ItemBlock Bomb)
      , List.repeat 2 (EntityBlock Crate)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "📦⬜⬜⬜💣"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "💣⬜😊⬜📦"
            ]
    , [ List.repeat 2 (EntityBlock (Enemy Rat))
      , List.repeat 3 (ItemBlock Bomb)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜📦⬜📦⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    ]


goblinTrails : List (Generator Game)
goblinTrails =
    [ [ List.repeat 1 (EntityBlock (Enemy (Goblin Left)))
      , List.repeat 1 HoleBlock
      ]
        |> List.concat
        |> Game.Build.generator
            [ "❌⬜💣⬜❌"
            , "❌⬜⬜⬜❌"
            , "❌⬜⬜⬜❌"
            , "❌⬜⬜⬜❌"
            , "❌⬜😊⬜❌"
            ]
    , [ List.repeat 1 (EntityBlock (Enemy (Goblin Down)))
      , List.repeat 1 (EntityBlock (Enemy (Goblin Up)))
      , List.repeat 1 HoleBlock
      , List.repeat 1 (ItemBlock Bomb)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "❌❌❌❌❌"
            , "❌⬜📦⬜❌"
            , "❌⬜⬜⬜❌"
            , "❌⬜⬜⬜❌"
            , "❌⬜😊⬜❌"
            ]
    , [ List.repeat 1 (EntityBlock (Enemy (Goblin Right)))
      , List.repeat 1 (EntityBlock (Enemy (Goblin Left)))
      , List.repeat 1 (EntityBlock (Enemy (Goblin Down)))
      , List.repeat 2 HoleBlock
      ]
        |> List.concat
        |> Game.Build.generator
            [ "❌❌❌❌❌"
            , "⬜⬜📦⬜⬜"
            , "⬜⬜💣⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜😊⬜⬜"
            ]
    , [ List.repeat 1 (EntityBlock (Enemy (Goblin Left)))
      , List.repeat 1 (EntityBlock (Enemy (Goblin Down)))
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
    [ [ List.repeat 1 (EntityBlock (Enemy Golem))
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
    , [ List.repeat 2 (EntityBlock (Enemy Golem))
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
    , [ List.repeat 3 (EntityBlock (Enemy Golem))
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
    , [ List.repeat 1 (EntityBlock (Enemy Golem))
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

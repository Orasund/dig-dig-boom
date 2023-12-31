module World.Trial exposing (..)

import Array exposing (Array)
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Game)
import Game.Build exposing (BuildingBlock(..))
import Random exposing (Generator)


fromInt : Int -> Maybe (Generator Game)
fromInt i =
    Array.get i asArray


asArray : Array (Generator Game)
asArray =
    [ [ List.repeat 1 (EntityBlock (Enemy Rat))
      , List.repeat 2 (ItemBlock InactiveBomb)
      , List.repeat 1 (ItemBlock Heart)
      ]
        |> List.concat
        |> Game.Build.generator
            [ "💣⬜⬜⬜💣"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "⬜⬜⬜⬜⬜"
            , "💣⬜😊⬜💣"
            ]
    , [ List.repeat 2 (EntityBlock (Enemy Rat))
      , List.repeat 5 (ItemBlock InactiveBomb)
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
      , List.repeat 3 (ItemBlock InactiveBomb)
      , List.repeat 2 (EntityBlock Crate)
      , List.repeat 1 (ItemBlock Heart)
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
      , List.repeat 2 (ItemBlock InactiveBomb)
      , List.repeat 1 (ItemBlock Heart)
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
        |> Array.fromList

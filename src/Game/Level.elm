module Game.Level exposing (..)

import Dict exposing (Dict)
import Entity exposing (Entity(..), Item(..))
import Game exposing (Cell)
import Math


type alias Level =
    { content : List Entity
    , items : List Item
    , valid : Dict ( Int, Int ) Cell -> Bool
    }


new : (Dict ( Int, Int ) Cell -> Bool) -> List Item -> List Entity -> Level
new validate items content =
    { content = content
    , items = items
    , valid = validate
    }


neighbors4 : ( Int, Int ) -> Dict ( Int, Int ) Cell -> List (Maybe Entity)
neighbors4 ( x, y ) dict =
    [ ( x + 1, y )
    , ( x - 1, y )
    , ( x, y + 1 )
    , ( x, y - 1 )
    ]
        |> List.filter Math.posIsValid
        |> List.map
            (\pos ->
                dict |> Dict.get pos |> Maybe.map .entity
            )


neighbors8 : ( Int, Int ) -> Dict ( Int, Int ) Cell -> List (Maybe Entity)
neighbors8 ( x, y ) dict =
    [ ( x + 1, y )
    , ( x - 1, y )
    , ( x, y + 1 )
    , ( x, y - 1 )
    , ( x + 1, y + 1 )
    , ( x + 1, y - 1 )
    , ( x - 1, y + 1 )
    , ( x - 1, y - 1 )
    ]
        |> List.filter Math.posIsValid
        |> List.map
            (\pos ->
                dict |> Dict.get pos |> Maybe.map .entity
            )


diagNeighbors : ( Int, Int ) -> Dict ( Int, Int ) Cell -> List (Maybe Entity)
diagNeighbors ( x, y ) dict =
    [ ( x + 1, y + 1 )
    , ( x + 1, y - 1 )
    , ( x - 1, y + 1 )
    , ( x - 1, y - 1 )
    ]
        |> List.filter Math.posIsValid
        |> List.map
            (\pos ->
                dict |> Dict.get pos |> Maybe.map .entity
            )


count : (a -> Bool) -> List a -> Int
count fun list =
    list |> List.filter fun |> List.length

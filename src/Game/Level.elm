module Game.Level exposing (..)

import Cell exposing (Cell(..))
import Dict exposing (Dict)
import Math


type alias Level =
    { content : List Cell
    , valid : Dict ( Int, Int ) Cell -> Bool
    }


new : (Dict ( Int, Int ) Cell -> Bool) -> List Cell -> Level
new validate content =
    { content = content
    , valid = validate
    }


neighbors4 : ( Int, Int ) -> Dict ( Int, Int ) Cell -> List (Maybe Cell)
neighbors4 ( x, y ) dict =
    [ ( x + 1, y )
    , ( x - 1, y )
    , ( x, y + 1 )
    , ( x, y - 1 )
    ]
        |> List.filter Math.posIsValid
        |> List.map
            (\pos ->
                dict |> Dict.get pos
            )


neighbors8 : ( Int, Int ) -> Dict ( Int, Int ) Cell -> List (Maybe Cell)
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
                dict |> Dict.get pos
            )


diagNeighbors : ( Int, Int ) -> Dict ( Int, Int ) Cell -> List (Maybe Cell)
diagNeighbors ( x, y ) dict =
    [ ( x + 1, y + 1 )
    , ( x + 1, y - 1 )
    , ( x - 1, y + 1 )
    , ( x - 1, y - 1 )
    ]
        |> List.filter Math.posIsValid
        |> List.map
            (\pos ->
                dict |> Dict.get pos
            )


isPlayer : Cell -> Bool
isPlayer cell =
    case cell of
        PlayerCell _ ->
            True

        _ ->
            False


count : (a -> Bool) -> List a -> Int
count fun list =
    list |> List.filter fun |> List.length

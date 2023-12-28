module Game.Build exposing (..)

import Dict exposing (Dict)
import Entity exposing (Entity(..), Item(..))
import Game exposing (Cell, Game)
import Math


type BuildingBlock
    = EntityBlock Entity
    | ItemBlock Item
    | HoleBlock


fromBlocks : List ( ( Int, Int ), BuildingBlock ) -> Game
fromBlocks blocks =
    blocks
        |> List.foldl
            (\( pos, block ) ->
                case block of
                    EntityBlock entity ->
                        Game.insert pos entity

                    ItemBlock item ->
                        Game.placeItem pos item

                    HoleBlock ->
                        Game.removeFloor pos
            )
            Game.empty


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

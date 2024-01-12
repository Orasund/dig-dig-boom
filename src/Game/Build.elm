module Game.Build exposing (BuildingBlock(..), fromEmojis, generator)

import Config
import Dict exposing (Dict)
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Cell, Game)
import Math
import Position
import Random exposing (Generator)


type BuildingBlock
    = EntityBlock Entity
    | ItemBlock Item
    | HoleBlock


generator : List String -> List BuildingBlock -> Generator Game
generator emojis blocks =
    let
        dict =
            fromEmojis emojis

        rec () =
            Position.asGrid
                { columns = Config.roomSize
                , rows = Config.roomSize
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
                |> Random.map fromBlocks
                |> Random.andThen
                    (\game ->
                        if validator game.cells then
                            Random.constant game

                        else
                            Random.lazy rec
                    )
    in
    rec ()


fromEmojis : List String -> Dict ( Int, Int ) BuildingBlock
fromEmojis rows =
    rows
        |> List.indexedMap
            (\y strings ->
                strings
                    |> String.toList
                    |> List.indexedMap
                        (\x string ->
                            parseEmoji string
                                |> Maybe.map (\block -> ( ( x, y ), block ))
                        )
                    |> List.filterMap identity
            )
        |> List.concat
        |> Dict.fromList


parseEmoji : Char -> Maybe BuildingBlock
parseEmoji string =
    case string of
        '😊' ->
            EntityBlock Player |> Just

        '📦' ->
            EntityBlock Crate |> Just

        '💣' ->
            EntityBlock (InactiveBomb Bomb) |> Just

        '🧨' ->
            EntityBlock ActiveSmallBomb |> Just

        '❌' ->
            HoleBlock |> Just

        '🐀' ->
            EntityBlock (Enemy Goblin) |> Just

        '🧱' ->
            EntityBlock Wall |> Just

        '⬜' ->
            Nothing

        _ ->
            Nothing


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


validator =
    \_ -> True



{--\dict ->
        dict
            |> Dict.toList
            |> List.all
                (\( pos, cell ) ->
                    case cell.entity of
                        Enemy _ ->
                            neighbors4 pos dict
                                |> List.all
                                    (\c ->
                                        case c of
                                            Just (Enemy _) ->
                                                False

                                            _ ->
                                                True
                                    )

                        Player ->
                            (count ((==) Nothing)
                                (neighbors4 pos dict)
                                > 1
                            )
                                && (diagNeighbors pos dict
                                        |> List.all
                                            (\c ->
                                                case c of
                                                    Just (Enemy _) ->
                                                        False

                                                    _ ->
                                                        True
                                            )
                                   )

                        {--Crate ->
                            count ((==) (Just Crate))
                                (neighbors4 pos dict)
                                < 1--}
                        _ ->
                            True
                )--}


count : (a -> Bool) -> List a -> Int
count fun list =
    list |> List.filter fun |> List.length


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

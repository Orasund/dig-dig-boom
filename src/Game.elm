module Game exposing (fromCells, move)

import Cell
    exposing
        ( Cell(..)
        , EffectType(..)
        , EnemyType(..)
        , ItemType(..)
        , Wall(..)
        )
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Player exposing (Game)


move : { from : ( Int, Int ), to : ( Int, Int ) } -> Game -> Maybe Game
move args game =
    if game.cells |> Dict.member args.to then
        Nothing

    else
        game.cells
            |> Dict.get args.from
            |> Maybe.map
                (\a ->
                    game.cells
                        |> Dict.insert args.to a
                        |> Dict.remove args.from
                        |> (\cells ->
                                { game
                                    | cells = cells
                                }
                           )
                )


fromCells : Dict ( Int, Int ) Cell -> Game
fromCells cells =
    { cells = cells
    , player = Player.init
    }

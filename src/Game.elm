module Game exposing (Game, attackPlayer, fromCells, move, remove, slide)

import Cell
    exposing
        ( Cell(..)
        , EffectType(..)
        , EnemyType(..)
        , Wall(..)
        )
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Math
import Player exposing (PlayerData)
import Position


type alias Game =
    { player : PlayerData
    , cells : Dict ( Int, Int ) Cell
    }


remove : ( Int, Int ) -> Game -> Game
remove pos game =
    { game | cells = game.cells |> Dict.remove pos }


move : { from : ( Int, Int ), to : ( Int, Int ) } -> Game -> Maybe Game
move args game =
    if Math.posIsValid args.to && (Dict.member args.to game.cells |> not) then
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

    else
        Nothing


slide : ( Int, Int ) -> Direction -> Game -> Game
slide position direction game =
    let
        newLocation : ( Int, Int )
        newLocation =
            direction
                |> Direction.toCoord
                |> Position.addTo position
    in
    case
        game
            |> move
                { from = position
                , to = newLocation
                }
    of
        Just a ->
            slide newLocation direction a

        Nothing ->
            game


fromCells : Dict ( Int, Int ) Cell -> Game
fromCells cells =
    { cells = cells
    , player = Player.init
    }


attackPlayer : ( Int, Int ) -> Game -> Game
attackPlayer location game =
    let
        player =
            game.player |> Player.removeLife
    in
    { game
        | player = player
        , cells =
            if player.lifes > 0 then
                game.cells

            else
                game.cells
                    |> Dict.insert location (EffectCell Bone)
    }

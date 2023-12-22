module Game.Update exposing (..)

import Cell exposing (Cell(..), EnemyType)
import Component.Actor exposing (Actor)
import Dict
import Direction exposing (Direction(..))
import Enemy
import Player exposing (Game)
import Position


updateGame : Actor -> Game -> Game
updateGame playerCell game =
    game.cells
        |> Dict.toList
        |> List.foldl
            (updateCell playerCell)
            game


updateCell : Actor -> ( ( Int, Int ), Cell ) -> Game -> Game
updateCell playerCell ( position, cell ) game =
    case cell of
        EnemyCell enemy _ ->
            updateEnemy position enemy playerCell game

        EffectCell _ ->
            { game | cells = game.cells |> Dict.remove position }

        StunnedCell enemy id ->
            { game | cells = game.cells |> Dict.update position (always <| Just <| EnemyCell enemy id) }

        _ ->
            game


updateEnemy : ( Int, Int ) -> EnemyType -> Actor -> Game -> Game
updateEnemy position enemyType playerCell =
    attackPlayer position playerCell
        >> Enemy.enemyBehaviour position enemyType playerCell


applyDirection : Int -> Direction -> ( Int, Int ) -> Game -> ( Actor, Game )
applyDirection size dir location game =
    --if direction == dir then
    ( ( location, dir )
    , { game | cells = game.cells |> Player.face location dir }
    )
        |> Player.move size
        |> (\( newPlayerCell, newGame ) ->
                ( newPlayerCell
                , updateGame newPlayerCell newGame
                )
           )



{--else
        playerCellAndGame
        |> Tuple.mapSecond
                (\game ->
                    { game | cells = game.cells |> Player.face location dir }
                )--}


attackPlayer : ( Int, Int ) -> Actor -> Game -> Game
attackPlayer location (( playerLocation, _ ) as playerCell) game =
    [ Up, Down, Left, Right ]
        |> List.filter
            (\direction ->
                direction
                    |> Direction.toCoord
                    |> (==) (playerLocation |> Position.coordTo location)
            )
        |> List.head
        |> Maybe.map (always (game |> Player.attack playerCell))
        |> Maybe.withDefault game

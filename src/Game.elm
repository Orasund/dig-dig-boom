module Game exposing (applyDirection)

import Cell
    exposing
        ( Cell(..)
        , EffectType(..)
        , EnemyType(..)
        , ItemType(..)
        , SolidType(..)
        )
import Component.Map as Map exposing (Actor)
import Dict
import Direction exposing (Direction(..))
import Player exposing (Game)
import Position


applyDirection : Int -> Direction -> ( Actor, Game ) -> ( Actor, Game )
applyDirection size dir (( ( location, direction ), _ ) as playerCellAndGame) =
    if direction == dir then
        playerCellAndGame
            |> Player.move size
            |> (\( newPlayerCell, game ) ->
                    ( newPlayerCell
                    , updateGame newPlayerCell game
                    )
               )

    else
        playerCellAndGame
            |> Tuple.mapSecond
                (\game ->
                    { game | cells = game.cells |> Player.face location dir }
                )


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
        >> specialBehaviour position enemyType playerCell


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


specialBehaviour : ( Int, Int ) -> EnemyType -> Actor -> Game -> Game
specialBehaviour currentLocation enemyType ( playerLocation, _ ) game =
    case enemyType of
        PlacedBombe ->
            [ Up, Down, Left, Right ]
                |> List.foldl
                    (placedBombeBehavoiur currentLocation)
                    game
                |> (\g ->
                        { g | cells = g.cells |> Dict.update currentLocation (always (Just (EffectCell Smoke))) }
                   )

        monster ->
            let
                moveDirection : Direction
                moveDirection =
                    currentLocation
                        |> Position.coordTo playerLocation
                        |> Direction.fromCoord
                        |> Maybe.withDefault Direction.Left

                actor : Actor
                actor =
                    ( currentLocation, moveDirection )

                newLocation : ( Int, Int )
                newLocation =
                    actor |> Map.posFront 1
            in
            case game.cells |> Dict.get newLocation of
                Nothing ->
                    { game
                        | cells =
                            game.cells
                                |> Map.move actor
                    }

                Just (ItemCell _) ->
                    { game
                        | cells =
                            game.cells
                                |> Map.move actor
                    }

                Just (SolidCell solid) ->
                    if
                        Cell.resistancy solid
                            <= (case monster of
                                    PlacedBombe ->
                                        0

                                    Oger ->
                                        3

                                    Goblin ->
                                        2

                                    Rat ->
                                        1
                               )
                    then
                        { game
                            | cells =
                                game.cells
                                    |> Dict.update newLocation
                                        (always (Cell.decomposing solid |> Maybe.map SolidCell))
                        }

                    else
                        game

                _ ->
                    game


placedBombeBehavoiur : ( Int, Int ) -> Direction -> Game -> Game
placedBombeBehavoiur location direction game =
    let
        newLocation =
            ( location, direction ) |> Map.posFront 1
    in
    { game
        | cells =
            game.cells
                |> Dict.update
                    newLocation
                    (\elem ->
                        case elem of
                            Just (EnemyCell _ _) ->
                                Just <| EffectCell Bone

                            Nothing ->
                                Just <| EffectCell Smoke

                            _ ->
                                elem
                    )
    }

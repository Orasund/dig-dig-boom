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
            |> Tuple.mapSecond (Tuple.mapSecond (Player.face location dir))


updateGame : Actor -> Game -> Game
updateGame playerCell (( _, map ) as game) =
    map
        |> Dict.toList
        |> List.foldl
            (updateCell playerCell)
            game


updateCell : Actor -> ( ( Int, Int ), Cell ) -> Game -> Game
updateCell playerCell ( position, cell ) =
    case cell of
        EnemyCell enemy _ ->
            updateEnemy position enemy playerCell

        EffectCell _ ->
            Tuple.mapSecond (Dict.remove position)

        StunnedCell enemy id ->
            Tuple.mapSecond (Dict.update position (always <| Just <| EnemyCell enemy id))

        _ ->
            identity


updateEnemy : ( Int, Int ) -> EnemyType -> Actor -> Game -> Game
updateEnemy position enemyType playerCell =
    attackPlayer position playerCell
        >> specialBehaviour position enemyType playerCell


attackPlayer : ( Int, Int ) -> Actor -> Game -> Game
attackPlayer location (( playerLocation, _ ) as playerCell) ( playerData, map ) =
    [ Up, Down, Left, Right ]
        |> List.filter
            (\direction ->
                direction
                    |> Direction.toCoord
                    |> (==) (playerLocation |> Position.coordTo location)
            )
        |> List.head
        |> Maybe.map (always (( playerData, map ) |> Player.attack playerCell))
        |> Maybe.withDefault ( playerData, map )


specialBehaviour : ( Int, Int ) -> EnemyType -> Actor -> Game -> Game
specialBehaviour currentLocation enemyType ( playerLocation, _ ) (( _, map ) as game) =
    case enemyType of
        PlacedBombe ->
            [ Up, Down, Left, Right ]
                |> List.foldl
                    (placedBombeBehavoiur currentLocation)
                    game
                |> Tuple.mapSecond
                    (Dict.update currentLocation (always (Just (EffectCell Smoke))))

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
            game
                |> (case map |> Dict.get newLocation of
                        Nothing ->
                            Tuple.mapSecond
                                (Map.move actor)

                        Just (ItemCell _) ->
                            Tuple.mapSecond
                                (Map.move actor)

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
                                Tuple.mapSecond <|
                                    Dict.update newLocation <|
                                        always (Cell.decomposing solid |> Maybe.map SolidCell)

                            else
                                identity

                        _ ->
                            identity
                   )


placedBombeBehavoiur : ( Int, Int ) -> Direction -> Game -> Game
placedBombeBehavoiur location direction game =
    let
        newLocation =
            ( location, direction ) |> Map.posFront 1
    in
    game
        |> Tuple.mapSecond
            (Dict.update
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
            )

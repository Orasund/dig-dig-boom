module Player exposing
    ( Game
    , PlayerData
    , attack
    , face
    , init
    , move
    , placeBombe
    )

import Cell
    exposing
        ( Cell(..)
        , EffectType(..)
        , EnemyType(..)
        , ItemType(..)
        , Wall(..)
        )
import Component.Actor as Map exposing (Actor)
import Config
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Math
import Position


type alias PlayerData =
    { bombs : Int
    , lifes : Int
    }


type alias Game =
    { player : PlayerData
    , cells : Dict ( Int, Int ) Cell
    }


init : PlayerData
init =
    { bombs = 0
    , lifes = 1
    }


removeLife : PlayerData -> PlayerData
removeLife player =
    { player | lifes = player.lifes - 1 |> max 0 }


addLife : PlayerData -> PlayerData
addLife player =
    { player | lifes = player.lifes + 1 |> min Config.maxLifes }


face :
    ( Int, Int )
    -> Direction
    -> Dict ( Int, Int ) Cell
    -> Dict ( Int, Int ) Cell
face position direction map =
    map
        |> Dict.insert position (PlayerCell direction)


attack : Actor -> Game -> Game
attack ( location, _ ) game =
    let
        player =
            game.player |> removeLife
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


move : Int -> ( Actor, Game ) -> ( Actor, Game )
move worldSize ( ( location, direction ) as playerCell, game ) =
    let
        outOfBound : Bool
        outOfBound =
            location
                |> (\( x, y ) ->
                        case direction of
                            Up ->
                                y == 0

                            Down ->
                                y == worldSize

                            Left ->
                                x == 0

                            Right ->
                                x == worldSize
                   )

        newLocation : ( Int, Int )
        newLocation =
            playerCell |> Map.posFront 1

        newPlayerCell : Actor
        newPlayerCell =
            playerCell |> Tuple.mapFirst (always newLocation)

        playerData =
            game.player
    in
    if outOfBound then
        ( playerCell, game )

    else
        case game.cells |> Dict.get newLocation of
            Just InactiveBombCell ->
                ( newPlayerCell
                , { game
                    | player = playerData |> addBombe
                    , cells = game.cells |> Map.move playerCell
                  }
                )

            Just HeartCell ->
                ( newPlayerCell
                , { game
                    | player = playerData |> addLife
                    , cells = game.cells |> Map.move playerCell
                  }
                )

            Just (EnemyCell enemy id) ->
                ( playerCell
                , { game | cells = throwEnemy playerCell enemy id game.cells }
                )

            Just (EffectCell _) ->
                if playerData.bombs > 0 then
                    ( newPlayerCell
                    , { game
                        | player = { playerData | bombs = playerData.bombs - 1 }
                        , cells =
                            game.cells
                                |> Map.move playerCell
                                |> Dict.insert location InactiveBombCell
                      }
                    )

                else
                    ( newPlayerCell, game )

            Just CrateCell ->
                game.cells
                    |> pushCrate newLocation direction
                    |> Maybe.map
                        (\cells ->
                            ( newPlayerCell
                            , { game
                                | cells =
                                    cells
                                        |> Map.move playerCell
                              }
                            )
                        )
                    |> Maybe.withDefault ( playerCell, game )

            Nothing ->
                ( newPlayerCell
                , { game
                    | player = playerData
                    , cells =
                        game.cells
                            |> Map.move playerCell
                  }
                )

            _ ->
                ( playerCell
                , { game | cells = game.cells |> face location direction }
                )


pushCrate : ( Int, Int ) -> Direction -> Dict ( Int, Int ) Cell -> Maybe (Dict ( Int, Int ) Cell)
pushCrate pos dir cells =
    let
        newPos =
            dir
                |> Direction.toCoord
                |> Position.addTo pos
    in
    Dict.get pos cells
        |> Maybe.andThen
            (\from ->
                if
                    Dict.get newPos
                        cells
                        == Nothing
                        && Math.posIsValid newPos
                then
                    cells
                        |> Dict.insert newPos from
                        |> Dict.remove pos
                        |> Just

                else
                    Nothing
            )


throwEnemy : Actor -> EnemyType -> String -> Dict ( Int, Int ) Cell -> Dict ( Int, Int ) Cell
throwEnemy (( _, direction ) as playerCell) enemyType enemyId currentMap =
    let
        newLocation : ( Int, Int )
        newLocation =
            playerCell |> Map.posFront 1
    in
    currentMap
        |> Dict.update newLocation (always (Just <| StunnedCell enemyType enemyId))
        |> (case
                currentMap
                    |> Dict.get (playerCell |> Map.posFront 2)
            of
                Nothing ->
                    \newMap ->
                        newMap
                            |> Map.move ( newLocation, direction )
                            |> (case
                                    newMap
                                        |> Dict.get (playerCell |> Map.posFront 3)
                                of
                                    Nothing ->
                                        Map.move ( playerCell |> Map.posFront 2, direction )

                                    _ ->
                                        identity
                               )

                _ ->
                    identity
           )


placeBombe : Actor -> Game -> Maybe Game
placeBombe playerCell game =
    takeFromInventory game.player
        |> Maybe.map
            (\playerData ->
                { game | player = playerData }
                    |> itemAction playerCell Bomb
            )


takeFromInventory : PlayerData -> Maybe PlayerData
takeFromInventory playerData =
    if playerData.bombs > 0 then
        Just { playerData | bombs = playerData.bombs - 1 }

    else
        Nothing


addBombe : PlayerData -> PlayerData
addBombe playerData =
    { playerData
        | bombs =
            playerData.bombs
                + 1
                |> min Config.maxBombs
    }


itemAction : Actor -> ItemType -> Game -> Game
itemAction playerCell consumable game =
    (case consumable of
        Bomb ->
            applyBombe playerCell game

        HealthPotion ->
            applyHealthPotion game
    )
        |> Maybe.withDefault { game | player = game.player |> addBombe }


applyHealthPotion : Game -> Maybe Game
applyHealthPotion game =
    if game.player.lifes < 3 then
        Just
            { game
                | player =
                    removeLife game.player
            }

    else
        Nothing


applyBombe : Actor -> Game -> Maybe Game
applyBombe playerCell game =
    let
        specialCase : Wall -> Maybe Game
        specialCase solidType =
            Cell.decomposing solidType
                |> Maybe.map
                    (\solid ->
                        { game
                            | cells =
                                game.cells
                                    |> Dict.insert (playerCell |> Map.posFront 1)
                                        (WallCell solid)
                        }
                    )

        id : String
        id =
            let
                ( front_x, front_y ) =
                    playerCell |> Map.posFront 1
            in
            "bombe_"
                ++ String.fromInt front_x
                ++ "_"
                ++ String.fromInt front_y

        cell =
            EnemyCell PlacedBomb id

        frontPos : ( Int, Int )
        frontPos =
            playerCell |> Map.posFront 1

        map =
            game.cells
    in
    case map |> Dict.get frontPos of
        Nothing ->
            { game
                | cells =
                    game.cells |> Dict.insert frontPos cell
            }
                |> Just

        Just (EffectCell _) ->
            { game
                | cells =
                    game.cells |> Dict.insert frontPos cell
            }
                |> Just

        Just (WallCell solidType) ->
            specialCase solidType

        _ ->
            Nothing

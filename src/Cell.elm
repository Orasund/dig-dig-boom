module Cell exposing
    ( Cell(..)
    , EffectType(..)
    , EnemyType(..)
    , ItemType(..)
    , SolidType
    , decomposing
    , generator
    , getImage
    , resistancy
    , tutorial
    )

import Dict exposing (Dict)
import Direction exposing (Direction(..))
import PixelEngine.Tile exposing (Tile)
import Random exposing (Generator)
import View.Tile as Tile


type ItemType
    = Bombe
    | HealthPotion


type EnemyType
    = PlacedBombe
    | Oger
    | Goblin
    | Rat


type EffectType
    = Smoke
    | Bone


type Cell
    = PlayerCell Direction
    | SolidCell SolidType
    | EnemyCell EnemyType String
    | StunnedCell EnemyType String
    | ItemCell ItemType
    | EffectCell EffectType


type SolidType
    = StoneWall
    | StoneBrickWall
    | DirtWall


decomposing : SolidType -> Maybe SolidType
decomposing solidType =
    case solidType of
        DirtWall ->
            Nothing

        StoneWall ->
            Just DirtWall

        StoneBrickWall ->
            Just StoneWall


getImage : Cell -> Tile msg
getImage cell =
    case cell of
        PlayerCell a ->
            (case a of
                Down ->
                    Tile.player_down

                Up ->
                    Tile.player_up

                Left ->
                    Tile.player_left

                Right ->
                    Tile.player_right
            )
                Tile.colorWhite

        SolidCell DirtWall ->
            Tile.dirt_wall Tile.colorBrown

        SolidCell StoneWall ->
            Tile.stone_wall Tile.colorGray

        SolidCell StoneBrickWall ->
            Tile.stone_brick_wall Tile.colorGray

        ItemCell Bombe ->
            Tile.bombe Tile.colorGreen

        ItemCell HealthPotion ->
            Tile.health_potion Tile.colorGreen

        EnemyCell enemy id ->
            (case enemy of
                PlacedBombe ->
                    Tile.placed_bombe id

                Oger ->
                    Tile.oger id

                Goblin ->
                    Tile.goblin id

                Rat ->
                    Tile.rat id
            )
                Tile.colorRed

        StunnedCell enemy id ->
            (case enemy of
                PlacedBombe ->
                    Tile.placed_bombe id

                Oger ->
                    Tile.oger id

                Goblin ->
                    Tile.goblin id

                Rat ->
                    Tile.rat id
            )
                Tile.colorYellow

        EffectCell effect ->
            (case effect of
                Smoke ->
                    Tile.smoke

                Bone ->
                    Tile.bone
            )
                Tile.colorWhite



--_ ->
--   ( 7, 12 )


resistancy : SolidType -> Int
resistancy solid =
    case solid of
        StoneWall ->
            3

        StoneBrickWall ->
            4

        DirtWall ->
            2


tutorial : Int -> Dict ( Int, Int ) Cell
tutorial num =
    List.range 0 (16 - 1)
        |> List.concatMap
            (\y ->
                List.range 0 (16 - 1)
                    |> List.map (\x -> ( x, y ))
            )
        |> List.filterMap
            (\(( x, y ) as pos) ->
                (if 2 <= x && x <= 13 && 7 <= y && y <= 8 then
                    case num of
                        5 ->
                            case pos of
                                ( 13, 8 ) ->
                                    Just <| EnemyCell Rat "rat_1"

                                ( 11, 7 ) ->
                                    Just <| EnemyCell Oger "Oger_1"

                                ( 8, 7 ) ->
                                    Just <| SolidCell <| DirtWall

                                ( 3, 8 ) ->
                                    Just <| (ItemCell <| Bombe)

                                ( 7, 8 ) ->
                                    Just <| (ItemCell <| Bombe)

                                _ ->
                                    Nothing

                        4 ->
                            case pos of
                                ( 9, 7 ) ->
                                    Just <| SolidCell StoneBrickWall

                                ( 9, 8 ) ->
                                    Just <| SolidCell StoneWall

                                ( 13, 7 ) ->
                                    Just <| EnemyCell Goblin "goblin_1"

                                ( 7, 8 ) ->
                                    Just <| (ItemCell <| Bombe)

                                ( 8, 8 ) ->
                                    Just <| (ItemCell <| Bombe)

                                _ ->
                                    Nothing

                        3 ->
                            case pos of
                                ( 10, 8 ) ->
                                    Just <| SolidCell StoneWall

                                ( 13, 7 ) ->
                                    Just <| EnemyCell Goblin "goblin_1"

                                ( 11, 8 ) ->
                                    Just <| (ItemCell <| Bombe)

                                _ ->
                                    Nothing

                        2 ->
                            case pos of
                                ( 9, 7 ) ->
                                    Just <| SolidCell StoneWall

                                ( 11, 7 ) ->
                                    Just <| (SolidCell <| DirtWall)

                                ( 9, 8 ) ->
                                    Just <| (SolidCell <| DirtWall)

                                ( 13, 7 ) ->
                                    Just <| EnemyCell Goblin "goblin_1"

                                ( 7, 8 ) ->
                                    Just <| (ItemCell <| Bombe)

                                _ ->
                                    Nothing

                        _ ->
                            case pos of
                                ( 9, 7 ) ->
                                    Just <| SolidCell StoneWall

                                ( 13, 7 ) ->
                                    Just <| EnemyCell Rat "rat_1"

                                ( 7, 8 ) ->
                                    Just <| (ItemCell <| Bombe)

                                _ ->
                                    Nothing

                 else
                    Just (SolidCell StoneBrickWall)
                )
                    |> Maybe.map
                        (\a ->
                            ( pos, a )
                        )
            )
        |> Dict.fromList


generator : Generator (Maybe Cell)
generator =
    Random.int 0 500
        |> Random.andThen
            (\r ->
                if r < 50 then
                    Random.constant <| Just <| SolidCell <| DirtWall

                else if r < 150 then
                    Random.constant <| Just <| SolidCell StoneWall

                else if r < 200 then
                    Random.constant <| Just <| SolidCell StoneBrickWall

                else if r < 225 then
                    Random.constant <| Just <| ItemCell Bombe

                else if r < 230 then
                    Random.constant <| Just <| ItemCell HealthPotion

                else if r < 235 then
                    Random.float 0 1
                        |> Random.andThen
                            (\id ->
                                Random.constant <| Just <| EnemyCell Rat <| "Rat" ++ String.fromFloat id
                            )

                else if r < 238 then
                    Random.float 0 1
                        |> Random.andThen
                            (\id ->
                                Random.constant <| Just <| EnemyCell Goblin <| "Goblin" ++ String.fromFloat id
                            )

                else if r < 239 then
                    Random.float 0 1
                        |> Random.andThen
                            (\id ->
                                Random.constant <| Just <| EnemyCell Oger <| "Oger" ++ String.fromFloat id
                            )

                else
                    Random.constant <| Nothing
            )

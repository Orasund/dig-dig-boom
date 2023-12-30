module World exposing (..)

import Dict exposing (Dict)
import Direction exposing (Direction)
import Game.Build exposing (neighbors4)
import Game.Level exposing (Level)
import Position
import Random exposing (Generator, Seed)


type Node
    = Room
        { seed : Seed
        , level : Level
        , solved : Bool
        }
    | Wall


type alias World =
    { nodes : Dict ( Int, Int ) Node
    , player : ( Int, Int )
    }


new : Seed -> World
new seed =
    { nodes =
        Dict.singleton ( 0, 0 )
            ({ seed = seed
             , level = { dungeon = 0, stage = 0 }
             , solved = False
             }
                |> Room
            )
    , player = ( 0, 0 )
    }


move : Direction -> World -> Maybe World
move dir world =
    let
        newPos =
            dir
                |> Direction.toVector
                |> Position.addToVector world.player
    in
    case Dict.get newPos world.nodes of
        Just (Room _) ->
            { world | player = newPos } |> Just

        _ ->
            Nothing


solveRoom : World -> Generator World
solveRoom world =
    let
        ( x, y ) =
            world.player
    in
    [ ( x + 1, y ), ( x - 1, y ), ( x, y + 1 ), ( x, y - 1 ) ]
        |> List.filter (\( posX, posY ) -> Dict.member ( posX, posY ) world.nodes |> not)
        |> List.foldl
            (\pos ->
                Random.andThen
                    (\dict ->
                        generateNode pos world
                            |> Random.map
                                (\node ->
                                    Dict.insert pos node dict
                                )
                    )
            )
            (Random.constant world.nodes)
        |> Random.map
            (Dict.update ( x, y )
                (\maybe ->
                    maybe
                        |> Maybe.map
                            (\node ->
                                case node of
                                    Room room ->
                                        Room { room | solved = True }

                                    _ ->
                                        node
                            )
                )
            )
        |> Random.map (\nodes -> { world | nodes = nodes })


generateNode : ( Int, Int ) -> World -> Generator Node
generateNode ( x, y ) world =
    if y >= 0 then
        Random.constant Wall

    else
        let
            neighbors =
                [ ( x + 1, y ), ( x - 1, y ), ( x, y + 1 ), ( x, y - 1 ) ]
                    |> List.foldl
                        (\pos out ->
                            case Dict.get pos world.nodes of
                                Just (Room _) ->
                                    { out | rooms = out.rooms + 1 }

                                Just Wall ->
                                    { out | wall = out.wall + 1 }

                                _ ->
                                    out
                        )
                        { rooms = 0, wall = 0 }
        in
        Random.weighted
            ( if neighbors.rooms == 0 then
                5

              else if neighbors.rooms == 1 then
                4

              else
                0
            , Random.independentSeed
                |> Random.map
                    (\seed ->
                        { seed = seed
                        , level = { dungeon = 42, stage = 42 }
                        , solved = False
                        }
                            |> Room
                    )
            )
            [ ( if (y == -1) && abs x == 1 then
                    0

                else
                    toFloat (1 + abs (x // 2))
              , Random.constant Wall
              )
            ]
            |> Random.andThen identity

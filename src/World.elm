module World exposing (..)

import Dict exposing (Dict)
import Direction exposing (Direction)
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
    , stages : Dict Int Int
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
    , stages = Dict.empty
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
        |> List.foldl (\pos -> Random.andThen (insertRandomNode pos))
            (Random.constant world)
        |> Random.map
            (\w ->
                { w
                    | nodes =
                        w.nodes
                            |> Dict.update ( x, y )
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
                }
            )


insertRandomNode : ( Int, Int ) -> World -> Generator World
insertRandomNode ( x, y ) world =
    let
        dungeon =
            abs y // 2

        stage =
            (Dict.get dungeon world.stages |> Maybe.withDefault 0) + 1
    in
    if y >= 0 then
        { world | nodes = world.nodes |> Dict.insert ( x, y ) Wall } |> Random.constant

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
                        { world
                            | nodes =
                                world.nodes
                                    |> Dict.insert ( x, y )
                                        ({ seed = seed
                                         , level = { dungeon = dungeon, stage = stage }
                                         , solved = False
                                         }
                                            |> Room
                                        )
                            , stages = world.stages |> Dict.insert dungeon stage
                        }
                    )
            )
            [ ( if (y == -1) && abs x == 1 then
                    0

                else
                    toFloat (1 + abs x)
              , { world | nodes = world.nodes |> Dict.insert ( x, y ) Wall } |> Random.constant
              )
            ]
            |> Random.andThen identity

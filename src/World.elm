module World exposing (..)

import Dict exposing (Dict)
import Direction exposing (Direction)
import Position
import Random exposing (Generator, Seed)


type RoomSort
    = Trial Int
    | Stage { difficulty : Int }


type Node
    = Room
        { seed : Seed
        , sort : RoomSort
        , solved : Bool
        }
    | Wall


type alias World =
    { nodes : Dict ( Int, Int ) Node
    , player : ( Int, Int )
    , stages : Dict Int Int
    , trials : Int
    , difficulty : Int
    }


new : Seed -> World
new seed =
    { nodes =
        [ ( ( 0, 0 )
          , Room
                { seed = seed
                , sort = Trial 0
                , solved = False
                }
          )
        ]
            |> Dict.fromList
    , player = ( 0, 0 )
    , stages = Dict.empty
    , trials = 1
    , difficulty = 0
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
    case world.nodes |> Dict.get ( x, y ) of
        Just (Room room) ->
            [ ( x + 1, y ), ( x - 1, y ), ( x, y + 1 ), ( x, y - 1 ) ]
                |> List.filter (\( posX, posY ) -> Dict.member ( posX, posY ) world.nodes |> not)
                |> List.foldl (\pos -> Random.andThen (insertRandomNode pos))
                    (Random.constant world)
                |> Random.map
                    (\w ->
                        { w
                            | nodes = w.nodes |> Dict.insert ( x, y ) (Room { room | solved = True })
                        }
                    )

        _ ->
            Random.constant world


insertWall : ( Int, Int ) -> World -> World
insertWall ( x, y ) world =
    { world
        | nodes = world.nodes |> Dict.insert ( x, y ) Wall
    }


insertStage : ( Int, Int ) -> World -> Generator World
insertStage ( x, y ) world =
    Random.map
        (\seed ->
            { world
                | nodes =
                    world.nodes
                        |> Dict.insert ( x, y )
                            ({ seed = seed
                             , sort = Stage { difficulty = world.difficulty |> min ((abs x + abs y) // 2) }
                             , solved = False
                             }
                                |> Room
                            )
            }
        )
        Random.independentSeed


insertTrail : ( Int, Int ) -> World -> Generator World
insertTrail pos world =
    Random.independentSeed
        |> Random.map
            (\seed ->
                { world
                    | nodes =
                        world.nodes
                            |> Dict.insert pos
                                ({ seed = seed
                                 , sort = Trial world.trials
                                 , solved = False
                                 }
                                    |> Room
                                )
                    , trials = world.trials + 1
                    , difficulty = world.difficulty + 1
                }
            )


insertRandomNode : ( Int, Int ) -> World -> Generator World
insertRandomNode ( x, y ) world =
    let
        neighbors =
            [ ( x + 1, y ), ( x - 1, y ), ( x, y + 1 ), ( x, y - 1 ) ]
                |> List.foldl
                    (\pos out ->
                        case Dict.get pos world.nodes of
                            Just (Room { sort }) ->
                                case sort of
                                    Stage _ ->
                                        { out | rooms = out.rooms + 1 }

                                    Trial _ ->
                                        { out | trails = out.trails + 1 }

                            Just Wall ->
                                { out | wall = out.wall + 1 }

                            _ ->
                                out
                    )
                    { rooms = 0
                    , wall = 0
                    , trails = 0
                    }
    in
    if x == 0 && y < 0 then
        insertTrail ( x, y ) world

    else
        insertWall ( x, y ) world |> Random.constant



{--if
        y >= 0 || (neighbors.rooms + neighbors.trails > 1)
        --|| (neighbors.rooms + neighbors.trails > 1 && Dict.size world.nodes > Config.minWorldSize)
    then
        insertWall ( x, y ) world |> Random.constant

    else if x == 0 && modBy 2 y == 0 then
        insertTrail ( x, y ) world

    else
        Random.weighted
            ( if Dict.size world.nodes <= Config.minWorldSize then
                0

              else
                toFloat (abs x // 4) + 1
            , insertWall ( x, y ) world |> Random.constant
            )
            [ ( 3
              , insertStage ( x, y ) world
              )
            , ( if neighbors.trails == 0 then
                    1

                else
                    0
              , insertTrail ( x, y ) world
              )
            ]
            |> Random.andThen identity
            --}

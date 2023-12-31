module World exposing (..)

import Dict exposing (Dict)
import Direction exposing (Direction)
import Position
import Random exposing (Generator, Seed)
import World.Level exposing (Level)


type RoomSort
    = Trial Int
    | Stage Level


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
    }


new : Seed -> World
new seed =
    { nodes =
        Dict.singleton ( 0, 0 )
            ({ seed = seed
             , sort = Stage { dungeon = 0, stage = 0 }
             , solved = False
             }
                |> Room
            )
    , player = ( 0, 0 )
    , stages = Dict.empty
    , trials = 0
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


insertWall : ( Int, Int ) -> World -> World
insertWall ( x, y ) world =
    { world
        | nodes = world.nodes |> Dict.insert ( x, y ) Wall
    }


insertStage : ( Int, Int ) -> World -> Generator World
insertStage ( x, y ) world =
    let
        dungeon =
            abs y // 2

        stage =
            { dungeon = dungeon
            , stage = (Dict.get dungeon world.stages |> Maybe.withDefault 0) + 1
            }
    in
    Random.independentSeed
        |> Random.map
            (\seed ->
                { world
                    | nodes =
                        world.nodes
                            |> Dict.insert ( x, y )
                                ({ seed = seed
                                 , sort = Stage stage
                                 , solved = False
                                 }
                                    |> Room
                                )
                    , stages = world.stages |> Dict.insert stage.dungeon stage.stage
                }
            )


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
    if y >= 0 || neighbors.trails > 0 then
        insertWall ( x, y ) world |> Random.constant

    else
        Random.weighted
            ( 1
            , insertWall ( x, y ) world |> Random.constant
            )
            [ ( if neighbors.rooms <= 1 then
                    3

                else
                    0
              , if neighbors.wall > 1 || abs x > 5 then
                    insertTrail ( x, y ) world

                else
                    insertStage ( x, y ) world
              )
            ]
            |> Random.andThen identity

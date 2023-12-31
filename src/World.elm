module World exposing (..)

import Dict exposing (Dict)
import Direction exposing (Direction)
import Position
import Random exposing (Generator, Seed)
import World.Level exposing (Level)


type RoomSort
    = TrialRoom Int
    | LevelRoom Level


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
    }


new : Seed -> World
new seed =
    { nodes =
        Dict.singleton ( 0, 0 )
            ({ seed = seed
             , sort = LevelRoom { dungeon = 0, stage = 0 }
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

        neighbors =
            [ ( x + 1, y ), ( x - 1, y ), ( x, y + 1 ), ( x, y - 1 ) ]
                |> List.foldl
                    (\pos out ->
                        case Dict.get pos world.nodes of
                            Just (Room { sort }) ->
                                case sort of
                                    LevelRoom _ ->
                                        { out | rooms = out.rooms + 1 }

                                    TrialRoom _ ->
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

        insertWall =
            { world
                | nodes = world.nodes |> Dict.insert ( x, y ) Wall
            }
                |> Random.constant

        insertRoom room =
            Random.independentSeed
                |> Random.map
                    (\seed ->
                        { world
                            | nodes =
                                world.nodes
                                    |> Dict.insert ( x, y )
                                        ({ seed = seed
                                         , sort = room
                                         , solved = False
                                         }
                                            |> Room
                                        )
                            , stages = world.stages |> Dict.insert dungeon stage
                        }
                    )
    in
    if y >= 0 || neighbors.trails > 0 then
        insertWall

    else
        Random.weighted
            ( 1
            , insertWall
            )
            [ ( if neighbors.rooms <= 1 then
                    3

                else
                    0
              , insertRoom
                    (if neighbors.wall > 1 || abs x > 5 then
                        TrialRoom 0

                     else
                        LevelRoom { dungeon = dungeon, stage = stage }
                    )
              )
            ]
            |> Random.andThen identity

module Game.Level exposing (..)

import Config
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..))
import Game exposing (Cell, Game)
import Game.Build exposing (BuildingBlock(..))
import Position
import Random exposing (Generator)


type alias Level =
    { blocks : List BuildingBlock
    , valid : Dict ( Int, Int ) Cell -> Bool
    }


new : (Dict ( Int, Int ) Cell -> Bool) -> List BuildingBlock -> Level
new validate blocks =
    { blocks = blocks
    , valid = validate
    }


toGame : Level -> Generator Game
toGame level =
    Position.asGrid
        { columns = Config.mapSize - 1
        , rows = Config.mapSize - 1
        }
        |> shuffle
        |> Random.map
            (\list ->
                List.map2 Tuple.pair list level.blocks
            )
        |> Random.map Game.Build.fromBlocks
        |> Random.andThen
            (\game ->
                if level.valid game.cells then
                    Random.constant game

                else
                    Random.lazy (\() -> toGame level)
            )


generate : Generator Game
generate =
    Random.uniform
        golemLevel
        []
        |> Random.andThen toGame


ratLevel : Level
ratLevel =
    [ List.repeat 3 (EntityBlock (Enemy Rat))
    , List.repeat 5 (EntityBlock Crate)
    , List.repeat 3 (ItemBlock InactiveBomb)
    , [ EntityBlock Player
      , ItemBlock Heart
      , HoleBlock
      ]
    ]
        |> List.concat
        |> new validator


goblinLevel : Level
goblinLevel =
    [ List.repeat 5 (EntityBlock Crate)
    , [ Player |> EntityBlock
      , Enemy (Goblin Left) |> EntityBlock
      , Enemy (Goblin Right) |> EntityBlock
      , Enemy (Goblin Down) |> EntityBlock
      , ItemBlock Heart
      , HoleBlock
      ]
    , List.repeat 3 (ItemBlock InactiveBomb)
    ]
        |> List.concat
        |> new validator


golemLevel : Level
golemLevel =
    [ List.repeat 3 (EntityBlock (Enemy Golem))
    , List.repeat 3 (ItemBlock InactiveBomb)
    , List.repeat 2 HoleBlock
    , List.repeat 5 (EntityBlock Crate)
    , [ ItemBlock Heart
      , Player |> EntityBlock
      ]
    ]
        |> List.concat
        |> new validator


validator =
    \dict ->
        dict
            |> Dict.toList
            |> List.all
                (\( pos, cell ) ->
                    case cell.entity of
                        Enemy _ ->
                            Game.Build.neighbors4 pos dict
                                |> List.all
                                    (\c ->
                                        case c of
                                            Just (Enemy _) ->
                                                False

                                            _ ->
                                                True
                                    )

                        Player ->
                            (Game.Build.count ((==) Nothing)
                                (Game.Build.neighbors4 pos dict)
                                > 1
                            )
                                && (Game.Build.diagNeighbors pos dict
                                        |> List.all
                                            (\c ->
                                                case c of
                                                    Just (Enemy _) ->
                                                        False

                                                    _ ->
                                                        True
                                            )
                                   )

                        Crate ->
                            Game.Build.count ((==) (Just Crate))
                                (Game.Build.neighbors4 pos dict)
                                < 1

                        _ ->
                            True
                )


shuffle : List a -> Generator (List a)
shuffle list =
    Random.list (List.length list) (Random.float 0 1)
        |> Random.map
            (\rand ->
                list
                    |> List.map2 Tuple.pair rand
                    |> List.sortBy Tuple.first
                    |> List.map Tuple.second
            )

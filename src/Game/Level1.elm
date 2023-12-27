module Game.Level1 exposing (..)

import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..))
import Game.Level as Level exposing (Level)


new : Level
new =
    [ Enemy Rat
    , InactiveBomb
    , InactiveBomb
    , Crate
    , Crate
    , Crate
    , Player
    , Heart
    ]
        |> Level.new validator


level2 : Level
level2 =
    [ List.repeat 3 (Enemy Rat)
    , List.repeat 3 InactiveBomb
    , List.repeat 5 Crate
    , [ Player
      , Heart
      ]
    ]
        |> List.concat
        |> Level.new validator


level3 : Level
level3 =
    [ List.repeat 3 InactiveBomb
    , List.repeat 5 Crate
    , [ Player
      , Heart
      , Enemy (Goblin Left)
      , Enemy (Goblin Right)
      , Enemy (Goblin Down)
      ]
    ]
        |> List.concat
        |> Level.new validator


validator =
    \dict ->
        dict
            |> Dict.toList
            |> List.all
                (\( pos, cell ) ->
                    case cell.entity of
                        Enemy _ ->
                            Level.count ((==) (Just InactiveBomb))
                                (Level.neighbors4 pos dict)
                                < 1
                                && (Level.neighbors4 pos dict
                                        |> List.all
                                            (\c ->
                                                case c of
                                                    Just (Enemy _) ->
                                                        False

                                                    _ ->
                                                        True
                                            )
                                   )

                        Player ->
                            (Level.count ((==) Nothing)
                                (Level.neighbors4 pos dict)
                                > 1
                            )
                                && (Level.diagNeighbors pos dict
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
                            Level.count ((==) (Just Crate))
                                (Level.neighbors4 pos dict)
                                < 1

                        _ ->
                            True
                )

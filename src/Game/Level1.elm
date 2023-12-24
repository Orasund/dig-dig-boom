module Game.Level1 exposing (..)

import Dict
import Direction exposing (Direction(..))
import Entity exposing (EnemyType(..), Entity(..))
import Game.Level as Level exposing (Level)


new : Level
new =
    [ Enemy Rat "Rat_0"
    , InactiveBomb
    , InactiveBomb
    , Crate
    , Crate
    , Crate
    , Player Down
    , Heart
    ]
        |> Level.new validator


level2 : Level
level2 =
    [ Enemy Rat "Rat_0"
    , Enemy Rat "Rat_1"
    , InactiveBomb
    , InactiveBomb
    , InactiveBomb
    , Crate
    , Crate
    , Crate
    , Player Down
    , Heart
    ]
        |> Level.new validator


validator =
    \dict ->
        dict
            |> Dict.toList
            |> List.all
                (\( pos, cell ) ->
                    case cell.entity of
                        Enemy _ _ ->
                            Level.count ((==) (Just InactiveBomb))
                                (Level.neighbors4 pos dict)
                                < 1

                        Player _ ->
                            (Level.count ((==) Nothing)
                                (Level.neighbors4 pos dict)
                                > 1
                            )
                                && (Level.diagNeighbors pos dict
                                        |> List.all
                                            (\c ->
                                                case c of
                                                    Just (Enemy _ _) ->
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

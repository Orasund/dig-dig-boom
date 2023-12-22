module Game.Level1 exposing (..)

import Cell exposing (Cell(..), EnemyType(..), Wall(..))
import Dict
import Direction exposing (Direction(..))
import Game.Level as Level exposing (Level)


new : Level
new =
    [ EnemyCell Rat "Rat_0"
    , InactiveBombCell
    , InactiveBombCell
    , CrateCell
    , CrateCell
    , CrateCell
    , PlayerCell Down
    , HeartCell
    ]
        |> Level.new
            (\dict ->
                dict
                    |> Dict.toList
                    |> List.all
                        (\( pos, cell ) ->
                            case cell of
                                EnemyCell _ _ ->
                                    Level.count ((==) (Just InactiveBombCell))
                                        (Level.neighbors4 pos dict)
                                        < 1

                                PlayerCell _ ->
                                    (Level.count ((==) Nothing)
                                        (Level.neighbors4 pos dict)
                                        > 1
                                    )
                                        && (Level.diagNeighbors pos dict
                                                |> List.all
                                                    (\c ->
                                                        case c of
                                                            Just (EnemyCell _ _) ->
                                                                False

                                                            _ ->
                                                                True
                                                    )
                                           )

                                _ ->
                                    True
                        )
            )

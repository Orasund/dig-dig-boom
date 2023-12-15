module Component.Map exposing
    ( Actor
    , generator
    , move
    , posFront
    )

import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Position
import Random exposing (Generator)
import Result exposing (Result(..))


type alias Actor =
    ( ( Int, Int ), Direction )


posFront : Int -> Actor -> ( Int, Int )
posFront n ( position, direction ) =
    position
        |> Position.add
            (Direction.toCoord direction
                |> (\coord ->
                        { x = coord.x * n
                        , y = coord.y * n
                        }
                   )
            )


generator : Int -> Generator (( Int, Int ) -> Maybe a) -> Generator (Dict ( Int, Int ) a)
generator size fun =
    Random.list (size * size) fun
        |> Random.map
            (\list ->
                list
                    |> List.foldl
                        (\maybeA ( grid, xy ) ->
                            let
                                pos : ( Int, Int )
                                pos =
                                    ( modBy size xy
                                    , xy // size
                                    )
                            in
                            ( case maybeA pos of
                                Just a ->
                                    grid |> Dict.insert pos a

                                Nothing ->
                                    grid
                            , xy + 1
                            )
                        )
                        ( Dict.empty
                        , 0
                        )
                    |> Tuple.first
            )


move : Actor -> Dict ( Int, Int ) a -> Dict ( Int, Int ) a
move ( pos, dir ) grid =
    case grid |> Dict.get pos of
        Just a ->
            grid
                |> Dict.insert
                    (pos |> Position.add (Direction.toCoord dir))
                    a
                |> Dict.remove pos

        Nothing ->
            grid

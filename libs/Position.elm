module Position exposing (addVector, addToVector, vectorTo, random, asGrid)

{-|

@docs addVector, addToVector, vectorTo, random, asGrid

-}

import Direction exposing (Direction(..))
import Random exposing (Generator)


{-| Generate a grid of points
-}
asGrid : { columns : Int, rows : Int } -> List ( Int, Int )
asGrid { rows, columns } =
    List.range 0 (rows - 1)
        |> List.concatMap (\x -> List.range 0 (columns - 1) |> List.map (Tuple.pair x))


{-| Generate a position inside a grid.
-}
random : { columns : Int, rows : Int } -> Generator ( Int, Int )
random { rows, columns } =
    Random.pair (Random.int 0 (rows - 1)) (Random.int 0 (columns - 1))


{-| Create the vector from the second argument to the first.

    (1,1)
    |> vectorTo (1,2)
    --> { x = 0, y = 1 }

-}
vectorTo : ( number, number ) -> ( number, number ) -> { x : number, y : number }
vectorTo ( x1, y1 ) ( x2, y2 ) =
    { x = x1 - x2, y = y1 - y2 }


{-| Add coordinates to a position

    (2,3)
    |> addVector { x = 1, y = 0}
    --> (3,3)

-}
addVector : { x : number, y : number } -> ( number, number ) -> ( number, number )
addVector { x, y } ( x2, y2 ) =
    ( x2 + x, y2 + y )


{-| Add coordinates to a position

    { x = 1, y = 0 }
    |> addToVector (2,3)
    --> (3,3)

-}
addToVector : ( number, number ) -> { x : number, y : number } -> ( number, number )
addToVector ( x2, y2 ) { x, y } =
    ( x2 + x, y2 + y )

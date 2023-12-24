module Direction exposing (Direction(..), asList, mirror, rotateLeftwise, rotateRightwise, fromVector, toAngle, toVector)

{-|

@docs Direction, asList, mirror, rotateLeftwise, rotateRightwise, fromVector, toAngle, toVector

-}


{-| An abstract concept of a direction on a grid.
-}
type Direction
    = Up
    | Down
    | Left
    | Right


{-| Create a list of all directions
-}
asList : List Direction
asList =
    [ Up, Down, Left, Right ]


{-| Rotates a `Direction` for 180 Degrees.

    Up
    |> mirror
    --> Down

    Left
    |> mirror
    --> Right

-}
mirror : Direction -> Direction
mirror direction =
    case direction of
        Up ->
            Down

        Down ->
            Up

        Left ->
            Right

        Right ->
            Left


{-| Rotates a `Direction` clockwise

    Up
        |> rotateLeftwise
        --> Left

-}
rotateLeftwise : Direction -> Direction
rotateLeftwise direction =
    case direction of
        Up ->
            Left

        Left ->
            Down

        Down ->
            Right

        Right ->
            Up


{-| Rotates a `Direction` counter-clockwise

    Up
        |> rotateRightwise
        --> Right

-}
rotateRightwise : Direction -> Direction
rotateRightwise direction =
    case direction of
        Up ->
            Right

        Right ->
            Down

        Down ->
            Left

        Left ->
            Up


{-| Convert coordinates into a direction by comparing the sign

    { x = 0, y = 1 }
        |> fromVector
        --> Just Down

    { x = 0, y = -1 }
        |> fromVector
        --> Just Up

    { x = 1, y = 0 }
        |> fromVector
        --> Just Right

    { x = -1, y = 0 }
        |> fromVector
        --> Just Left

    { x = 1, y = 1 }
        |> fromVector
        --> Nothing

-}
fromVector : { x : number, y : number } -> Maybe Direction
fromVector pos =
    if pos.x == 0 then
        if pos.y > 0 then
            Just Down

        else
            Just Up

    else if pos.y == 0 then
        if pos.x > 0 then
            Just Right

        else
            Just Left

    else
        Nothing


{-| Convert a Direction into a coord.

    asList
        |> List.map toVector
        |> List.filterMap fromVector
        --> list

    Right
        |> toVector
        --> {x = 1, y = 0}

-}
toVector : Direction -> { x : number, y : number }
toVector dir =
    case dir of
        Right ->
            { x = 1, y = 0 }

        Down ->
            { x = 0, y = 1 }

        Left ->
            { x = -1, y = 0 }

        Up ->
            { x = 0, y = -1 }


{-| Convert a direction into an angle.
-}
toAngle : Direction -> Float
toAngle dir =
    case dir of
        Right ->
            0

        Up ->
            pi / 2

        Left ->
            pi

        Down ->
            3 * pi / 2

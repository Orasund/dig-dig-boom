module View.Cell exposing (..)

import Config
import Direction exposing (Direction(..))
import Entity exposing (EffectType(..), Enemy(..), Entity(..), Item(..))
import Html exposing (Attribute, Html)
import Image


sprite : List (Attribute msg) -> ( Int, Int ) -> Html msg
sprite attrs pos =
    Image.sprite
        (Image.pixelated :: attrs)
        { pos = pos
        , sheetColumns = 4
        , sheetRows = 8
        , url = "tileset.png"
        , height = Config.cellSize
        , width = Config.cellSize
        }


toHtml : List (Attribute msg) -> { frame : Int, playerDirection : Direction } -> Entity -> Html msg
toHtml attrs args cell =
    (case cell of
        Player ->
            directional ( 0, 4 )
                { direction = args.playerDirection
                , frame = args.frame
                }

        Crate ->
            ( 1, 3 )

        Item InactiveBomb ->
            ( 0, 2 )

        Item Heart ->
            ( 0, 3 )

        Enemy enemy ->
            fromEnemy { frame = args.frame } enemy

        Stunned enemy ->
            fromEnemy { frame = args.frame } enemy

        Particle effect ->
            case effect of
                Smoke ->
                    ( 2, 2 )

                Bone ->
                    ( 2, 3 )
    )
        |> sprite attrs


directional : ( Int, Int ) -> { direction : Direction, frame : Int } -> ( Int, Int )
directional ( x, y ) args =
    case args.direction of
        Down ->
            ( x + args.frame, y )

        Up ->
            ( x + args.frame, y + 1 )

        Left ->
            ( x + 2 + args.frame, y )

        Right ->
            ( x + 2 + args.frame, y + 1 )


fromEnemy : { frame : Int } -> Enemy -> ( Int, Int )
fromEnemy args enemy =
    case enemy of
        PlacedBomb ->
            ( 2 + args.frame, 1 )

        Goblin dir ->
            directional ( 0, 6 )
                { direction = dir
                , frame = args.frame
                }

        Rat ->
            ( 0 + args.frame, 1 )

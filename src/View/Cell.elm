module View.Cell exposing (..)

import Config
import Direction exposing (Direction(..))
import Entity exposing (EffectType(..), EnemyType(..), Entity(..))
import Html exposing (Attribute, Html)
import Image


sprite : List (Attribute msg) -> ( Int, Int ) -> Html msg
sprite attrs pos =
    Image.sprite
        (Image.pixelated :: attrs)
        { pos = pos
        , sheetColumns = 4
        , sheetRows = 6
        , url = "tileset.png"
        , height = Config.cellSize
        , width = Config.cellSize
        }


toHtml : List (Attribute msg) -> { frame : Int, playerDirection : Direction } -> Entity -> Html msg
toHtml attrs args cell =
    (case cell of
        Player ->
            case args.playerDirection of
                Down ->
                    ( 0 + args.frame, 4 )

                Up ->
                    ( 0 + args.frame, 5 )

                Left ->
                    ( 2 + args.frame, 4 )

                Right ->
                    ( 2 + args.frame, 5 )

        Crate ->
            ( 1, 3 )

        InactiveBomb ->
            ( 0, 2 )

        Heart ->
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


fromEnemy : { frame : Int } -> EnemyType -> ( Int, Int )
fromEnemy args enemy =
    case enemy of
        PlacedBomb ->
            ( 2 + args.frame, 1 )

        Oger ->
            ( 0 + args.frame, 0 )

        Goblin ->
            ( 3 + args.frame, 0 )

        Rat ->
            ( 0 + args.frame, 1 )

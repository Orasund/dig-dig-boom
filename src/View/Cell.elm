module View.Cell exposing (..)

import Cell exposing (Cell(..), EffectType(..), EnemyType(..))
import Config
import Direction exposing (Direction(..))
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


toHtml : List (Attribute msg) -> { frame : Int } -> Cell -> Html msg
toHtml attrs args cell =
    (case cell of
        PlayerCell a ->
            case a of
                Down ->
                    ( 0 + args.frame, 4 )

                Up ->
                    ( 0 + args.frame, 5 )

                Left ->
                    ( 2 + args.frame, 4 )

                Right ->
                    ( 2 + args.frame, 5 )

        CrateCell ->
            ( 1, 3 )

        InactiveBombCell ->
            ( 0, 2 )

        HeartCell ->
            ( 0, 3 )

        EnemyCell enemy id ->
            fromEnemy attrs args enemy

        StunnedCell enemy id ->
            fromEnemy attrs args enemy

        EffectCell effect ->
            case effect of
                Smoke ->
                    ( 2, 2 )

                Bone ->
                    ( 2, 3 )
    )
        |> sprite attrs


fromEnemy : List (Attribute msg) -> { frame : Int } -> EnemyType -> ( Int, Int )
fromEnemy attrs args enemy =
    case enemy of
        PlacedBomb ->
            ( 2 + args.frame, 1 )

        Oger ->
            ( 0 + args.frame, 0 )

        Goblin ->
            ( 3 + args.frame, 0 )

        Rat ->
            ( 0 + args.frame, 1 )

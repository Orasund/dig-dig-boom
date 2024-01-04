module View.Cell exposing (..)

import Config
import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item(..), ParticleSort(..))
import Game exposing (Game)
import Html exposing (Attribute, Html)
import Html.Style
import Image


sprite : List (Attribute msg) -> ( Int, Int ) -> Html msg
sprite attrs pos =
    Image.sprite
        (Image.pixelated :: attrs)
        { pos = pos
        , sheetColumns = 8
        , sheetRows = 8
        , url = "assets/tileset.png"
        , height = Config.cellSize
        , width = Config.cellSize
        }


border : List (Attribute msg) -> ( Int, Int ) -> Html msg
border attrs pos =
    Image.sprite
        (Image.pixelated :: attrs)
        { pos = pos
        , sheetColumns = 2
        , sheetRows = 2
        , url = "assets/border.png"
        , height = Config.cellSize
        , width = Config.cellSize
        }


floor : List (Attribute msg) -> Html msg
floor attrs =
    sprite attrs ( 0, 3 )


hole : List (Attribute msg) -> Html msg
hole attrs =
    sprite attrs ( 1, 2 )


holeTop : List (Attribute msg) -> Html msg
holeTop attrs =
    sprite attrs ( 0, 2 )


particle : List (Attribute msg) -> ParticleSort -> Html msg
particle attrs particleSort =
    (case particleSort of
        Smoke ->
            ( 0, 0 )

        Bone ->
            ( 2, 3 )
    )
        |> sprite attrs


toHtml : List (Attribute msg) -> { frame : Int, playerDirection : Direction } -> Entity -> Html msg
toHtml attrs args cell =
    (case cell of
        Door ->
            ( 2, 2 )

        Player ->
            directional ( 0, 4 )
                { direction = args.playerDirection
                , frame = args.frame
                }

        Sign _ ->
            ( 3, 2 )

        Crate ->
            ( 1, 3 )

        InactiveBomb _ ->
            ( 1, 6 )

        Enemy enemy ->
            fromEnemy
                { frame = args.frame
                , playerDirection = args.playerDirection
                }
                enemy

        Stunned enemy ->
            fromEnemy
                { frame = args.frame
                , playerDirection = args.playerDirection
                }
                enemy
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


fromEnemy : { frame : Int, playerDirection : Direction } -> Enemy -> ( Int, Int )
fromEnemy args enemy =
    case enemy of
        ActivatedBomb _ ->
            ( 2 + args.frame, 1 )

        Orc dir ->
            directional ( 4, 2 )
                { direction = dir
                , frame = args.frame
                }

        Goblin ->
            directional ( 4, 0 )
                { direction = Down
                , frame = args.frame
                }

        Doppelganger ->
            directional ( 4, 2 )
                { direction = Direction.mirror args.playerDirection
                , frame = args.frame
                }

        Rat ->
            ( 0 + args.frame, 1 )


borders : ( Int, Int ) -> Game -> List (Html msg)
borders ( x, y ) game =
    let
        attrs =
            [ Html.Style.positionAbsolute
            , Html.Style.top "0"
            ]
    in
    [ if Dict.member ( x - 1, y ) game.floor then
        border attrs ( 0, 1 ) |> Just

      else
        Nothing
    , if Dict.member ( x + 1, y ) game.floor then
        border attrs ( 1, 0 ) |> Just

      else
        Nothing
    , if Dict.member ( x, y - 1 ) game.floor then
        border attrs ( 0, 0 )
            |> Just

      else
        Nothing
    , if Dict.member ( x, y + 1 ) game.floor then
        border attrs ( 1, 1 ) |> Just

      else
        Nothing
    ]
        |> List.filterMap identity


item : List (Attribute msg) -> Item -> Html msg
item attrs i =
    (case i of
        Bomb ->
            ( 1, 6 )

        CrossBomb ->
            ( 3, 6 )
    )
        |> sprite attrs

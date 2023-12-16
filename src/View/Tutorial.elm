module View.Tutorial exposing (view)

import Cell exposing (Cell(..), EnemyType(..), ItemType(..), SolidType(..))
import Dict exposing (Dict)
import Html exposing (Html)
import PixelEngine.Tile exposing (Tile)
import Player exposing (PlayerData)
import View.Screen as Screen
import View.Tile as TileView


viewHint : Int -> List ( ( Int, Int ), Tile msg )
viewHint num =
    case num of
        5 ->
            List.concat
                [ [ ( ( 2, 5 ), TileView.arrow_left TileView.colorWhite )
                  , ( ( 3, 5 ), TileView.arrow_left TileView.colorWhite )
                  , ( ( 4, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 5, 5 ), TileView.arrow_right TileView.colorWhite )
                  ]
                , ( 6, 5 ) |> TileView.text "!" TileView.colorWhite
                , [ ( ( 7, 5 ), TileView.arrow_down TileView.colorWhite )
                  , ( ( 8, 5 ), TileView.arrow_down TileView.colorWhite )
                  , ( ( 9, 5 ), TileView.arrow_right TileView.colorWhite )
                  ]
                , ( 10, 5 ) |> TileView.text "!" TileView.colorWhite
                , [ ( ( 11, 5 ), TileView.arrow_right TileView.colorWhite )
                  ]
                ]

        4 ->
            List.concat
                [ [ ( ( 2, 5 ), TileView.arrow_down TileView.colorWhite )
                  , ( ( 3, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 4, 5 ), TileView.arrow_right TileView.colorWhite )
                  ]
                , ( 5, 5 ) |> TileView.text "!" TileView.colorWhite
                , [ ( ( 6, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 7, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 8, 5 ), TileView.arrow_right TileView.colorWhite )
                  ]
                , ( 9, 5 ) |> TileView.text "!" TileView.colorWhite
                , [ ( ( 10, 5 ), TileView.arrow_right TileView.colorWhite ) ]
                ]

        3 ->
            List.concat
                [ [ ( ( 2, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 3, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 4, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 5, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 6, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 7, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 8, 5 ), TileView.arrow_down TileView.colorWhite )
                  , ( ( 9, 5 ), TileView.arrow_down TileView.colorWhite )
                  , ( ( 10, 5 ), TileView.arrow_right TileView.colorWhite )
                  ]
                , ( 11, 5 ) |> TileView.text "!" TileView.colorWhite
                ]

        2 ->
            List.concat
                [ [ ( ( 2, 5 ), TileView.arrow_down TileView.colorWhite )
                  , ( ( 3, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 4, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 5, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 6, 5 ), TileView.arrow_right TileView.colorWhite )
                  ]
                , ( 7, 5 ) |> TileView.text "!" TileView.colorWhite
                ]

        _ ->
            List.concat
                [ [ ( ( 2, 5 ), TileView.arrow_down TileView.colorWhite )
                  , ( ( 3, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 4, 5 ), TileView.arrow_right TileView.colorWhite )
                  , ( ( 5, 5 ), TileView.arrow_right TileView.colorWhite )
                  ]
                , ( 6, 5 ) |> TileView.text "!" TileView.colorWhite
                ]


view : Maybe (Html msg) -> PlayerData -> Dict ( Int, Int ) Cell -> Int -> Html msg
view oldScreen player map num =
    let
        tutorialWorldScreen =
            Screen.world num
                map
                player
                (( 2, 4 )
                    |> TileView.text "hint:" TileView.colorWhite
                    |> List.append (viewHint num)
                )
    in
    case oldScreen of
        Just _ ->
            tutorialWorldScreen

        Nothing ->
            if player.lifes > 0 then
                tutorialWorldScreen

            else
                Screen.death

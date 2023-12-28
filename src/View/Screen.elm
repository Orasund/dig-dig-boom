module View.Screen exposing (death, menu, world)

import Config
import Dict
import Entity exposing (Enemy(..), Entity(..))
import Game exposing (Game)
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Keyed
import Html.Style
import Image
import Input exposing (Input)
import Layout
import View.Cell
import View.Controls
import View.Item


logo : Int -> Html msg
logo frame =
    Image.sprite [ Image.pixelated ]
        { url = "title_image.png"
        , width = 350
        , height = 350
        , sheetColumns = 2
        , sheetRows = 1
        , pos = ( frame, 0 )
        }


skull : Html msg
skull =
    Image.image [ Image.pixelated ]
        { url = "skull.png"
        , width = 350
        , height = 350
        }


death : List (Attribute msg) -> { onClick : msg } -> Html msg
death attrs args =
    [ [ "You have" |> Layout.text [ Layout.contentCentered ]
      , "died" |> Layout.text [ Layout.contentCentered ]
      ]
        |> Layout.column []
    , skull
    , [ "Press any" |> Layout.text [ Layout.contentCentered ]
      , "button" |> Layout.text [ Layout.contentCentered ]
      ]
        |> Layout.column []
    ]
        |> Layout.column
            ([ Html.Attributes.style "font-size" "60px"
             , Html.Attributes.style "color" "white"
             ]
                ++ Layout.asButton
                    { label = "Next Level"
                    , onPress = Just args.onClick
                    }
                ++ attrs
            )


menu : List (Attribute msg) -> { frame : Int, onClick : msg } -> Html msg
menu attrs args =
    [ [ "DIG" |> Layout.text [ Layout.contentCentered ]
      , "DIG" |> Layout.text [ Layout.contentCentered ]
      , "BOOM" |> Layout.text [ Layout.contentCentered ]
      ]
        |> Layout.column
            [ Html.Attributes.style "font-size" "60px"
            , Html.Attributes.style "color" "white"
            ]
    , logo args.frame
    ]
        |> Layout.column
            (Layout.asButton
                { label = "Next Level"
                , onPress = Just args.onClick
                }
                ++ attrs
            )


world :
    { score : Int
    , onInput : Input -> msg
    , frame : Int
    }
    -> Game
    -> Html msg
world args game =
    [ [ "Score:"
            ++ String.fromInt args.score
            |> Layout.text [ Html.Attributes.style "font-size" "32px" ]
      ]
        |> Layout.row
            [ Layout.contentWithSpaceBetween
            , Html.Attributes.style "color" "white"
            ]
    , (game.items
        |> Dict.toList
        |> List.map
            (\( ( x, y ), item ) ->
                ( "0_" ++ String.fromInt x ++ "_" ++ String.fromInt y
                , View.Item.toHtml
                    [ Html.Style.positionAbsolute
                    , Html.Attributes.style "left"
                        (String.fromFloat (Config.cellSize * toFloat x) ++ "px")
                    , Html.Attributes.style "top"
                        (String.fromFloat (Config.cellSize * toFloat y) ++ "px")
                    ]
                    item
                )
            )
      )
        ++ (game.cells
                |> Dict.toList
                |> List.map
                    (\( ( x, y ), cell ) ->
                        ( "1_" ++ String.fromInt cell.id
                        , View.Cell.toHtml
                            [ Html.Attributes.style "position" "absolute"
                            , Html.Attributes.style "left"
                                (String.fromFloat (Config.cellSize * toFloat x) ++ "px")
                            , Html.Attributes.style "top"
                                (String.fromFloat (Config.cellSize * toFloat y) ++ "px")
                            , Html.Attributes.style "transition" "left 0.2s,top 0.2s"
                            ]
                            { frame = args.frame
                            , playerDirection = game.playerDirection
                            }
                            cell.entity
                        )
                    )
           )
        |> List.sortBy Tuple.first
        |> Html.Keyed.node "div"
            [ Html.Attributes.style "position" "relative"
            , Html.Attributes.style "width" (String.fromFloat (Config.cellSize * toFloat Config.mapSize) ++ "px")
            , Html.Attributes.style "height" (String.fromFloat (Config.cellSize * toFloat Config.mapSize) ++ "px")
            , Html.Attributes.style "background-image" "url('groundTile.png')"
            , Html.Attributes.style "background-repeat" "repeat"
            , Html.Attributes.style "background-size"
                (String.fromFloat Config.cellSize
                    ++ "px "
                    ++ String.fromFloat Config.cellSize
                    ++ "px"
                )
            ]
    , [ Image.image [ Image.pixelated ]
            { url = "heart.png"
            , width = 64
            , height = 64
            }
            |> List.repeat (game.lifes - 1)
            |> Layout.row []
      ]
        |> Layout.row [ Layout.contentWithSpaceBetween ]
    , View.Controls.toHtml
        { onInput = args.onInput
        , bombs = game.bombs
        }
    ]
        |> Layout.column
            (Html.Attributes.style "width" "400px"
                :: Layout.centered
            )

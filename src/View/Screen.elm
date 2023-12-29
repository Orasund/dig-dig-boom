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
import Position
import Set
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
    , [ "R to undo" |> Layout.text [ Layout.contentCentered ]
      , "or" |> Layout.text [ Layout.contentCentered ]
      , "Space to retry" |> Layout.text [ Layout.contentCentered ]
      ]
        |> Layout.column []
    ]
        |> Layout.column
            ([ Html.Attributes.style "font-size" "60px"
             , Html.Attributes.style "color" "white"
             , Html.Attributes.class "dark-background"
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
            (Html.Attributes.class "dark-background"
                :: Layout.asButton
                    { label = "Next Level"
                    , onPress = Just args.onClick
                    }
                ++ attrs
            )


world :
    { onInput : Input -> msg
    , frame : Int
    }
    -> Game
    -> Html msg
world args game =
    [ (Position.asGrid
        { rows = Config.mapSize
        , columns = Config.mapSize
        }
        |> List.map
            (\( x, y ) ->
                ( "0_" ++ String.fromInt x ++ "_" ++ String.fromInt y
                , [ if game.floor |> Set.member ( x, y ) then
                        View.Cell.floor
                            [ Html.Style.positionAbsolute
                            , Html.Style.top "0"
                            ]

                    else
                        View.Cell.hole
                            [ Html.Style.positionAbsolute
                            , Html.Style.top "0"
                            ]
                  , game.items
                        |> Dict.get ( x, y )
                        |> Maybe.map
                            (\item ->
                                View.Item.toHtml
                                    [ Html.Style.positionAbsolute
                                    , Html.Style.top "0"
                                    ]
                                    item
                            )
                        |> Maybe.withDefault Layout.none
                  ]
                    ++ (if game.floor |> Set.member ( x, y ) |> not then
                            View.Cell.borders ( x, y ) game

                        else
                            []
                       )
                    |> Html.div
                        [ Html.Style.positionAbsolute
                        , Html.Attributes.style "left"
                            (String.fromFloat (Config.cellSize * toFloat x) ++ "px")
                        , Html.Attributes.style "top"
                            (String.fromFloat (Config.cellSize * toFloat y) ++ "px")
                        ]
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
            , Html.Attributes.style "border" "4px solid white"
            ]
    , View.Controls.toHtml
        { onInput = args.onInput
        , bombs = game.bombs
        , lifes = game.lifes
        }
    ]
        |> Layout.column
            (Html.Attributes.style "width" "400px"
                :: Layout.centered
            )

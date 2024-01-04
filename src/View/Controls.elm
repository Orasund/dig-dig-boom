module View.Controls exposing (..)

import Direction exposing (Direction(..))
import Entity exposing (Item(..))
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Style
import Image
import Input exposing (Input(..))
import Layout
import View.Cell


sprite : List (Attribute msg) -> ( Int, Int ) -> Html msg
sprite attrs pos =
    Image.sprite
        (Image.pixelated :: attrs)
        { pos = pos
        , sheetColumns = 2
        , sheetRows = 1
        , url = "controls.png"
        , height = 72
        , width = 72
        }


label : List (Attribute msg) -> String -> Html msg
label attrs title =
    title
        |> Layout.text []
        |> Layout.el
            ([ Html.Attributes.style "background-color" "white"
             , Html.Attributes.style "font-size" "12px"
             , Html.Attributes.style "width" "16px"
             , Html.Attributes.style "height" "16px"
             , Html.Style.boxSizingBorderBox
             ]
                ++ Layout.centered
                ++ attrs
            )


toHtml : { onInput : Input -> msg, item : Maybe Item, isLevelSelect : Bool } -> Html msg
toHtml args =
    [ [ {--[ (if args.isLevelSelect then
            ""

           else
            "Exit"
          )
            |> Layout.text [ Html.Attributes.style "color" "white" ]
            |> Layout.el
                ([ Html.Style.width "72px"
                 , Html.Style.height "72px"
                 ]
                    ++ Layout.centered
                )
        , label
            [ Html.Style.positionAbsolute
            , Html.Style.bottom "4px"
            , Html.Style.right "4px"
            ]
            "ESC"
        ]
            |> Html.div
                (Layout.asButton
                    { onPress = args.onInput InputOpenMap |> Just
                    , label = "Open Map"
                    }
                    ++ [ Html.Style.positionRelative
                       ]
                )--}
        [ (if args.isLevelSelect then
            ""

           else
            "Retry"
          )
            |> Layout.text []
            |> Layout.el
                ([ Html.Style.width "72px"
                 , Html.Style.height "72px"
                 , Html.Attributes.style "color" "white"
                 ]
                    ++ Layout.centered
                )
        , label
            [ Html.Style.positionAbsolute
            , Html.Style.bottom "4px"
            , Html.Style.right "4px"
            ]
            "C"
        ]
            |> Html.div
                (Layout.asButton
                    { onPress = args.onInput InputReset |> Just
                    , label = "Retry"
                    }
                    ++ [ Html.Style.positionRelative
                       ]
                )
      , [ sprite
            [ Html.Attributes.style "transform" "rotate(90deg)" ]
            ( 0, 0 )
        , label []
            "W"
            |> Layout.el
                ([ Html.Style.positionAbsolute
                 , Html.Style.top "0"
                 , Html.Style.width "72px"
                 , Html.Style.height "72px"
                 ]
                    ++ Layout.centered
                )
        ]
            |> Html.div
                (Html.Style.positionRelative
                    :: Layout.asButton
                        { onPress = args.onInput (InputDir Up) |> Just
                        , label = "Move Up"
                        }
                )
      , [ (if args.isLevelSelect then
            ""

           else
            "Undo"
          )
            |> Layout.text [ Html.Attributes.style "color" "white" ]
            |> Layout.el
                ([ Html.Style.width "72px"
                 , Html.Style.height "72px"
                 ]
                    ++ Layout.centered
                )
        , label
            [ Html.Style.positionAbsolute
            , Html.Style.bottom "4px"
            , Html.Style.right "0px"
            ]
            "R"
        ]
            |> Html.div
                (Html.Style.positionRelative
                    :: Layout.asButton
                        { onPress = args.onInput InputUndo |> Just
                        , label = "Undo"
                        }
                )
      ]
        |> Layout.row []
    , [ [ sprite
            []
            ( 0, 0 )
        , label
            []
            "A"
            |> Layout.el
                ([ Html.Style.positionAbsolute
                 , Html.Style.top "0"
                 , Html.Style.width "72px"
                 , Html.Style.height "72px"
                 ]
                    ++ Layout.centered
                )
        ]
            |> Html.div
                (Html.Style.positionRelative
                    :: Layout.asButton
                        { onPress = args.onInput (InputDir Left) |> Just
                        , label = "Move Left"
                        }
                )
      , Layout.el
            [ Html.Style.width "72px"
            , Html.Style.height "72px"
            ]
            Layout.none

      {--[ sprite [] ( 1, 0 )
        , if args.isLevelSelect then
            "Play"
                |> Layout.text [ Html.Attributes.style "color" "white" ]
                |> Layout.el
                    ([ Html.Style.width "72px"
                     , Html.Style.height "72px"
                     , Html.Style.positionAbsolute
                     , Html.Style.top "0"
                     ]
                        ++ Layout.centered
                    )

          else
            case args.item of
                Just item ->
                    View.Cell.item
                        [ Html.Attributes.style "position" "absolute"
                        , Html.Attributes.style "top" "4px"
                        , Html.Attributes.style "left" "4px"
                        ]
                        item

                Nothing ->
                    Layout.none
        , label
            [ Html.Style.positionAbsolute
            , Html.Style.bottom "0px"
            , Html.Style.right "4px"
            ]
            "SPACE"
        ]
            |> Html.div
                ([ Html.Attributes.style "position" "relative"
                 , Html.Style.width "72px"
                 , Html.Style.height "72px"
                 ]
                    ++ Layout.asButton
                        { onPress = args.onInput InputActivate |> Just
                        , label = "Place Bombe"
                        }
                )--}
      , [ sprite
            [ Html.Attributes.style "transform" "rotate(180deg)"
            ]
            ( 0, 0 )
        , label
            []
            "D"
            |> Layout.el
                ([ Html.Style.positionAbsolute
                 , Html.Style.top "0"
                 , Html.Style.width "72px"
                 , Html.Style.height "72px"
                 ]
                    ++ Layout.centered
                )
        ]
            |> Html.div
                (Html.Style.positionRelative
                    :: Layout.asButton
                        { onPress = args.onInput (InputDir Right) |> Just
                        , label = "Move Right"
                        }
                )
      ]
        |> Layout.row []
    , [ [ sprite
            [ Html.Attributes.style "transform" "rotate(-90deg)" ]
            ( 0, 0 )
        , label
            []
            "S"
            |> Layout.el
                ([ Html.Style.positionAbsolute
                 , Html.Style.top "0"
                 , Html.Style.width "72px"
                 , Html.Style.height "72px"
                 ]
                    ++ Layout.centered
                )
        ]
            |> Html.div
                (Html.Style.positionRelative
                    :: Layout.asButton
                        { onPress = args.onInput (InputDir Down) |> Just
                        , label = "Move Down"
                        }
                )
      ]
        |> Layout.row []
    ]
        |> Layout.column Layout.centered

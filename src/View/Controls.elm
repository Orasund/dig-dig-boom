module View.Controls exposing (..)

import Direction exposing (Direction(..))
import Entity exposing (Item(..))
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Style
import Input exposing (Input(..))
import Layout
import View.Bitmap


arrow : List (Attribute msg) -> Html msg
arrow attrs =
    control attrs


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
            |> Layout.text
                ([ Html.Style.positionAbsolute
                 , Html.Attributes.style "color" "white"
                 , Html.Style.bottom "0px"
                 , Html.Style.width "72px"
                 ]
                    ++ Layout.centered
                )
        , "R"
            |> Layout.text
                ([ Html.Style.positionAbsolute
                 , Html.Style.top "16px"
                 , Html.Style.left "20px"
                 , Html.Style.width "32px"
                 , Html.Style.height "32px"
                 , Html.Attributes.style "border" "4px solid white"
                 , Html.Attributes.style "font-size" "20px"
                 , Html.Attributes.style "color" "white"
                 , Html.Style.boxSizingBorderBox
                 ]
                    ++ Layout.centered
                )
        ]
            |> Html.div
                (Layout.asButton
                    { onPress = args.onInput InputReset |> Just
                    , label = "Retry"
                    }
                    ++ [ Html.Style.positionRelative
                       , Html.Style.width "72px"
                       , Html.Style.height "72px"
                       ]
                )
      , [ arrow
            [ Html.Attributes.style "transform" "rotate(90deg)" ]
        , "W"
            |> Layout.text
                ([ Html.Style.positionAbsolute
                 , Html.Style.bottom "16px"
                 , Html.Style.width "72px"
                 , Html.Attributes.style "font-size" "20px"
                 , Html.Attributes.style "color" "white"
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
            |> Layout.text
                ([ Html.Style.positionAbsolute
                 , Html.Attributes.style "color" "white"
                 , Html.Style.bottom "0px"
                 , Html.Style.width "72px"
                 ]
                    ++ Layout.centered
                )
        , "C"
            |> Layout.text
                ([ Html.Style.positionAbsolute
                 , Html.Style.top "16px"
                 , Html.Style.left "20px"
                 , Html.Style.width "32px"
                 , Html.Style.height "32px"
                 , Html.Attributes.style "border" "4px solid white"
                 , Html.Attributes.style "font-size" "20px"
                 , Html.Attributes.style "color" "white"
                 , Html.Style.boxSizingBorderBox
                 ]
                    ++ Layout.centered
                )
        ]
            |> Html.div
                ([ Html.Style.positionRelative
                 , Html.Style.width "72px"
                 , Html.Style.height "72px"
                 ]
                    ++ Layout.asButton
                        { onPress = args.onInput InputUndo |> Just
                        , label = "Undo"
                        }
                )
      ]
        |> Layout.row []
    , [ [ arrow []
        , "A"
            |> Layout.text
                ([ Html.Style.positionAbsolute
                 , Html.Style.top "0"
                 , Html.Style.right "20px"
                 , Html.Style.height "72px"
                 , Html.Attributes.style "font-size" "20px"
                 , Html.Attributes.style "color" "white"
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

      {--[ controlSquare [] 
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
      , [ arrow
            [ Html.Attributes.style "transform" "rotate(180deg)"
            ]
        , "D"
            |> Layout.text
                ([ Html.Style.positionAbsolute
                 , Html.Style.top "0"
                 , Html.Style.left "20px"
                 , Html.Style.height "72px"
                 , Html.Attributes.style "font-size" "20px"
                 , Html.Attributes.style "color" "white"
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
    , [ [ arrow
            [ Html.Attributes.style "transform" "rotate(-90deg)" ]
        , "S"
            |> Layout.text
                ([ Html.Style.positionAbsolute
                 , Html.Style.top "16px"
                 , Html.Style.width "72px"
                 , Html.Attributes.style "font-size" "20px"
                 , Html.Attributes.style "color" "white"
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


fromEmojis : List (Attribute msg) -> List String -> Html msg
fromEmojis attrs =
    View.Bitmap.fromEmojis attrs
        { color = "white"
        , pixelSize = 72 / 16
        }


controlSquare : List (Attribute msg) -> Html msg
controlSquare attrs =
    fromEmojis attrs
        [ "🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘❌❌❌❌❌❌❌❌❌❌❌❌❌❌🔘"
        , "🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘🔘"
        ]


control : List (Attribute msg) -> Html msg
control attrs =
    fromEmojis attrs
        [ "❌❌❌❌❌❌❌❌❌❌❌❌❌🔘🔘❌"
        , "❌❌❌❌❌❌❌❌❌❌❌🔘🔘❌🔘❌"
        , "❌❌❌❌❌❌❌❌❌🔘🔘❌❌❌🔘❌"
        , "❌❌❌❌❌❌❌❌🔘❌❌❌❌❌🔘❌"
        , "❌❌❌❌❌❌🔘🔘❌❌❌❌❌❌🔘❌"
        , "❌❌❌❌🔘🔘❌❌❌❌❌❌❌❌🔘❌"
        , "❌❌❌🔘❌❌❌❌❌❌❌❌❌❌🔘❌"
        , "❌❌🔘❌❌❌❌❌❌❌❌❌❌❌🔘❌"
        , "❌❌🔘❌❌❌❌❌❌❌❌❌❌❌🔘❌"
        , "❌❌❌🔘❌❌❌❌❌❌❌❌❌❌🔘❌"
        , "❌❌❌❌🔘🔘❌❌❌❌❌❌❌❌🔘❌"
        , "❌❌❌❌❌❌🔘🔘❌❌❌❌❌❌🔘❌"
        , "❌❌❌❌❌❌❌❌🔘❌❌❌❌❌🔘❌"
        , "❌❌❌❌❌❌❌❌❌🔘🔘❌❌❌🔘❌"
        , "❌❌❌❌❌❌❌❌❌❌❌🔘🔘❌🔘❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌🔘🔘❌"
        ]

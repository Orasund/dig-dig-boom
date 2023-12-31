module View.Controls exposing (..)

import Direction exposing (Direction(..))
import Entity exposing (Item(..))
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Style
import Image
import Input exposing (Input(..))
import Layout
import View.Item


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


toHtml : { onInput : Input -> msg, item : Maybe Item } -> Html msg
toHtml args =
    [ [ Layout.el
            (Layout.asButton
                { onPress = args.onInput InputOpenMap |> Just
                , label = "Open Map"
                }
                ++ [ Html.Style.width "72px"
                   , Html.Style.height "72px"
                   ]
            )
            (Layout.text [ Html.Attributes.style "color" "white" ] "Return to Map")
      , sprite
            (Html.Attributes.style "transform" "rotate(90deg)"
                :: Layout.asButton
                    { onPress = args.onInput (InputDir Up) |> Just
                    , label = "Move Up"
                    }
            )
            ( 0, 0 )
      , Layout.el
            (Layout.asButton
                { onPress = args.onInput InputUndo |> Just
                , label = "Undo"
                }
                ++ [ Html.Style.width "72px"
                   , Html.Style.height "72px"
                   ]
            )
            (Layout.text [ Html.Attributes.style "color" "white" ] "Undo")
      ]
        |> Layout.row []
    , [ sprite
            (Layout.asButton
                { onPress = args.onInput (InputDir Left) |> Just
                , label = "Move Left"
                }
            )
            ( 0, 0 )
      , (case args.item of
            Just item ->
                [ sprite [] ( 1, 0 )
                , View.Item.toHtml
                    [ Html.Attributes.style "position" "absolute"
                    , Html.Attributes.style "top" "11px"
                    , Html.Attributes.style "left" "11px"
                    ]
                    item
                ]

            Nothing ->
                [ sprite [] ( 1, 0 ) ]
        )
            |> Html.div
                (Html.Attributes.style "position" "relative"
                    :: Layout.asButton
                        { onPress = args.onInput InputActivate |> Just
                        , label = "Place Bombe"
                        }
                )
      , sprite
            (Html.Attributes.style "transform" "rotate(180deg)"
                :: Layout.asButton
                    { onPress = args.onInput (InputDir Right) |> Just
                    , label = "Move Right"
                    }
            )
            ( 0, 0 )
      ]
        |> Layout.row []
    , sprite
        (Html.Attributes.style "transform" "rotate(-90deg)"
            :: Layout.asButton
                { onPress = args.onInput (InputDir Down) |> Just
                , label = "Move Down"
                }
        )
        ( 0, 0 )
    ]
        |> Layout.column Layout.centered

module View.Controls exposing (..)

import Entity exposing (Item(..))
import Html exposing (Attribute, Html)
import Html.Attributes
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


toHtml : { onInput : Input -> msg, bombs : Int } -> Html msg
toHtml args =
    [ sprite
        (Html.Attributes.style "transform" "rotate(90deg)"
            :: Layout.asButton
                { onPress = args.onInput InputUp |> Just
                , label = "Move Up"
                }
        )
        ( 0, 0 )
    , Layout.row []
        [ sprite
            (Layout.asButton
                { onPress = args.onInput InputLeft |> Just
                , label = "Move Left"
                }
            )
            ( 0, 0 )
        , (if args.bombs > 0 then
            [ sprite [] ( 1, 0 )
            , View.Item.toHtml
                [ Html.Attributes.style "position" "absolute"
                , Html.Attributes.style "top" "11px"
                , Html.Attributes.style "left" "11px"
                ]
                InactiveBomb
            , String.fromInt args.bombs
                |> Layout.text
                    [ Html.Attributes.style "position" "absolute"
                    , Html.Attributes.style "right" "8px"
                    , Html.Attributes.style "bottom" "4px"
                    , Html.Attributes.style "color" "white"
                    , Html.Attributes.style "font-size" "20px"
                    ]
            ]

           else
            [ sprite [] ( 1, 0 ) ]
          )
            |> Html.div
                (Html.Attributes.style "position" "relative"
                    :: Layout.asButton
                        { onPress = args.onInput InputA |> Just
                        , label = "Place Bombe"
                        }
                )
        , sprite
            (Html.Attributes.style "transform" "rotate(180deg)"
                :: Layout.asButton
                    { onPress = args.onInput InputRight |> Just
                    , label = "Move Right"
                    }
            )
            ( 0, 0 )
        ]
    , sprite
        (Html.Attributes.style "transform" "rotate(-90deg)"
            :: Layout.asButton
                { onPress = args.onInput InputDown |> Just
                , label = "Move Down"
                }
        )
        ( 0, 0 )
    ]
        |> Layout.column Layout.centered

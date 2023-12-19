module View.Stylesheet exposing (..)

import Html exposing (Html)
import Html.Attributes


toHtml : Html msg
toHtml =
    Html.node "link"
        [ Html.Attributes.rel "stylesheet"
        , Html.Attributes.href "main.css"
        ]
        []

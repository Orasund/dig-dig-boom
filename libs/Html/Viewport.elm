module Html.Viewport exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes


fixedWidth : List (Attribute msg) -> Float -> Html msg
fixedWidth attrs width =
    Html.node "meta"
        ([ Html.Attributes.name "viewport"
         , Html.Attributes.attribute "content" ("user-scalable=no,width=" ++ String.fromFloat width)
         ]
            ++ attrs
        )
        []

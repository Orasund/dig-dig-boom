module View.Bomb exposing (..)

import Html exposing (Attribute, Html)
import Image


toHtml : List (Attribute msg) -> Html msg
toHtml attrs =
    Image.sprite
        (Image.pixelated :: attrs)
        { pos = ( 1, 0 )
        , sheetColumns = 2
        , sheetRows = 1
        , url = "items.png"
        , height = 64
        , width = 64
        }

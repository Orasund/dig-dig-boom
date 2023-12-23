module View.Bomb exposing (..)

import Html exposing (Html)
import Image


toHtml : Html msg
toHtml =
    Image.sprite
        [ Image.pixelated ]
        { pos = ( 1, 0 )
        , sheetColumns = 2
        , sheetRows = 1
        , url = "items.png"
        , height = 64
        , width = 64
        }

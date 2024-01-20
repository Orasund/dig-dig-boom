module View.World exposing (..)

import Config
import Html exposing (Attribute, Html)
import Image


nodeSize =
    Config.cellSize // 2


image : List (Attribute msg) -> ( Int, Int ) -> Html msg
image attrs pos =
    Image.sprite
        (Image.pixelated :: attrs)
        { pos = pos
        , sheetColumns = 4
        , sheetRows = 4
        , url = "overworld.png"
        , height = toFloat nodeSize
        , width = toFloat nodeSize
        }

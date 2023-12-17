module View.Item exposing (..)

import Cell exposing (ItemType(..))
import Html exposing (Html)
import Image


toHtml : ItemType -> Html msg
toHtml item =
    Image.sprite
        [ Image.pixelated ]
        { pos =
            case item of
                HealthPotion ->
                    ( 0, 0 )

                Bombe ->
                    ( 1, 0 )
        , sheetColumns = 2
        , sheetRows = 1
        , url = "items.png"
        , height = 64
        , width = 64
        }

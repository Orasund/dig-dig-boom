module View.Item exposing (..)

import Entity exposing (Item(..))
import Html exposing (Attribute, Html)
import Image


fromPos : List (Attribute msg) -> ( Int, Int ) -> Html msg
fromPos attrs pos =
    Image.sprite
        (Image.pixelated :: attrs)
        { pos = pos
        , sheetColumns = 2
        , sheetRows = 1
        , url = "items.png"
        , height = 50
        , width = 50
        }


toHtml : List (Attribute msg) -> Item -> Html msg
toHtml attrs item =
    (case item of
        Bomb ->
            ( 1, 0 )
    )
        |> fromPos attrs

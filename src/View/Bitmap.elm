module View.Bitmap exposing (..)

import Html exposing (Attribute, Html)
import Image


fromEmojis : List (Attribute msg) -> String -> List String -> Html msg
fromEmojis attrs color rows =
    rows
        |> List.indexedMap
            (\y string ->
                string
                    |> String.toList
                    |> List.indexedMap
                        (\x ->
                            Tuple.pair ( x, y )
                        )
            )
        |> List.concat
        |> List.filterMap
            (\( pos, char ) ->
                case char of
                    '🔘' ->
                        Just ( pos, color )

                    '❌' ->
                        Nothing

                    _ ->
                        Nothing
            )
        |> Image.bitmap attrs
            { columns = 16
            , rows = 16
            , pixelSize = 72 / 16
            }


empty : Html msg
empty =
    fromEmojis []
        "white"
        [ "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        , "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
        ]

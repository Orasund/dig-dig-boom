module View.Bitmap exposing (..)

import Html exposing (Attribute, Html)
import Image
import View.Color


fromEmojis : List (Attribute msg) -> { color : String, pixelSize : Float } -> List String -> Html msg
fromEmojis attrs args rows =
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
                    '⬜' ->
                        Just ( pos, View.Color.white )

                    '⬛' ->
                        Just ( pos, View.Color.black )

                    '🟨' ->
                        Just ( pos, View.Color.yellow )

                    '🟥' ->
                        Just ( pos, View.Color.red )

                    '🔘' ->
                        Just ( pos, args.color )

                    '❌' ->
                        Nothing

                    _ ->
                        Nothing
            )
        |> Image.bitmap attrs
            { columns = 16
            , rows = 16
            , pixelSize = args.pixelSize
            }


empty : List (Attribute msg) -> Html msg
empty attrs =
    fromEmojis attrs
        { color = "white"
        , pixelSize = 72
        }
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

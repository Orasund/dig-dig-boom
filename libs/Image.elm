module Image exposing (..)

{-| This module is a stand-alone module to view pixelimages
-}

import Html exposing (Attribute, Html)
import Html.Attributes


pixelated : Html.Attribute msg
pixelated =
    Html.Attributes.style "image-rendering" "pixelated"


sprite :
    List (Attribute msg)
    ->
        { url : String
        , width : Float
        , height : Float
        , pos : ( Int, Int )
        , sheetColumns : Int
        , sheetRows : Int
        }
    -> Html msg
sprite attrs args =
    let
        ( x, y ) =
            args.pos
    in
    Html.div
        ([ Html.Attributes.style "width" (String.fromFloat args.width ++ "px")
         , Html.Attributes.style "height" (String.fromFloat args.height ++ "px")
         , "url("
            ++ args.url
            ++ ") "
            |> Html.Attributes.style "background-image"
         , String.fromFloat (-args.width * toFloat x)
            ++ "px "
            ++ String.fromFloat (-args.height * toFloat y)
            ++ "px"
            |> Html.Attributes.style "background-position"
         , String.fromFloat (args.width * toFloat args.sheetColumns)
            ++ "px "
            ++ String.fromFloat (args.height * toFloat args.sheetRows)
            ++ "px"
            |> Html.Attributes.style "background-size"
         , Html.Attributes.style "background-repeat" "no-repeat"
         ]
            ++ attrs
        )
        []


image :
    List (Attribute msg)
    -> { url : String, width : Float, height : Float }
    -> Html msg
image attrs args =
    Html.img
        ([ pixelated
         , Html.Attributes.src args.url
         , Html.Attributes.style "width" (String.fromFloat args.width ++ "px")
         , Html.Attributes.style "height" (String.fromFloat args.height ++ "px")
         ]
            ++ attrs
        )
        []


bitmap :
    List (Attribute msg)
    ->
        { columns : Int
        , rows : Int
        , pixelSize : Float
        }
    -> List ( ( Int, Int ), String )
    -> Html msg
bitmap attrs args list =
    let
        width =
            String.fromFloat (toFloat args.columns * args.pixelSize) ++ "px"

        height =
            String.fromFloat (toFloat args.rows * args.pixelSize) ++ "px"
    in
    Html.div
        ([ Html.Attributes.style "width" width
         , Html.Attributes.style "height" height
         ]
            ++ attrs
        )
        [ Html.div
            [ list
                |> List.map
                    (\( ( x, y ), color ) ->
                        [ String.fromFloat (toFloat x * args.pixelSize) ++ "px"
                        , String.fromFloat (toFloat y * args.pixelSize) ++ "px"
                        , color
                        ]
                            |> String.join " "
                    )
                |> String.join ","
                |> Debug.log "string"
                |> Html.Attributes.style "box-shadow"
            , Html.Attributes.style "width" (String.fromFloat args.pixelSize ++ "px")
            , Html.Attributes.style "height" (String.fromFloat args.pixelSize ++ "px")
            ]
            []
        ]

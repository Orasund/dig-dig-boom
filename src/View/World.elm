module View.World exposing (..)

import Dict
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Keyed
import Html.Style
import Layout
import World exposing (Node(..), RoomSort(..), World)


toHtml : List (Attribute msg) -> World -> Html msg
toHtml attrs world =
    let
        ( centerX, centerY ) =
            world.player

        scale =
            5

        nodeSize =
            16
    in
    List.range (centerY - scale) (centerY + scale)
        |> List.concatMap
            (\y ->
                List.range (centerX - scale) (centerX + scale)
                    |> List.filterMap
                        (\x -> Dict.get ( x, y ) world.nodes |> Maybe.map (Tuple.pair ( x, y )))
            )
        |> List.map
            (\( ( x, y ), node ) ->
                ( "node_" ++ String.fromInt x ++ "_" ++ String.fromInt y
                , Layout.el
                    [ Html.Style.width (String.fromInt nodeSize ++ "px")
                    , Html.Style.height (String.fromInt nodeSize ++ "px")
                    , Html.Style.top (String.fromInt ((y - centerY) * nodeSize) ++ "px")
                    , Html.Style.left (String.fromInt ((x - centerX) * nodeSize) ++ "px")
                    , Html.Style.positionAbsolute
                    , Html.Attributes.style "background-color"
                        (case node of
                            Wall ->
                                "white"

                            Room { solved, sort } ->
                                if world.player == ( x, y ) then
                                    "blue"

                                else if solved then
                                    "green"

                                else
                                    case sort of
                                        TrialRoom _ ->
                                            "yellow"

                                        _ ->
                                            "red"
                        )
                    ]
                    Layout.none
                )
            )
        |> List.sortBy Tuple.first
        |> Html.Keyed.node "div"
            [ Html.Style.positionRelative
            , Html.Style.width (String.fromInt ((scale * 2 + 1) * nodeSize) ++ "px")
            , Html.Style.height (String.fromInt ((scale * 2 + 1) * nodeSize) ++ "px")
            ]
        |> Layout.el
            ([ Html.Attributes.class "dark-background"
             , Html.Style.width "400px"
             , Html.Style.height "700px"
             ]
                ++ Layout.centered
                ++ attrs
            )

module View.World exposing (..)

import Config
import Dict
import Html exposing (Attribute, Html)
import Html.Keyed
import Html.Style
import Image
import World exposing (Node(..), RoomSort(..), World)


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


toHtml : List (Attribute msg) -> World -> Html msg
toHtml attrs world =
    let
        ( centerX, centerY ) =
            world.player

        scale =
            5

        ( offsetX, offsetY ) =
            ( -nodeSize // 2, -nodeSize )
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
                , (case node of
                    Wall ->
                        ( 3, 0 )

                    Room { solved, sort } ->
                        ( if solved then
                            0

                          else
                            case sort of
                                Trial _ ->
                                    2

                                _ ->
                                    1
                        , if world.player == ( x, y ) then
                            1

                          else
                            0
                        )
                  )
                    |> image
                        [ Html.Style.width (String.fromInt nodeSize ++ "px")
                        , Html.Style.height (String.fromInt nodeSize ++ "px")
                        , Html.Style.top (String.fromInt ((y - centerY) * nodeSize + offsetY) ++ "px")
                        , Html.Style.left (String.fromInt ((x - centerX) * nodeSize + offsetX) ++ "px")
                        , Html.Style.positionAbsolute
                        ]
                )
            )
        |> List.sortBy Tuple.first
        |> Html.Keyed.node "div"
            (Html.Style.positionRelative :: attrs)

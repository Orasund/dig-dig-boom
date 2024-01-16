module View.Screen exposing (gameWon, menu, world)

import Config
import Dict
import Entity exposing (Enemy(..), Entity(..), Floor(..))
import Game exposing (Game)
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Keyed
import Html.Style
import Image
import Layout
import Position
import View.Cell
import View.Door


gameWon : Html msg
gameWon =
    [ "Thanks"
        |> Layout.text
            [ Html.Attributes.style "font-size" "46px"
            , Layout.contentCentered
            ]
    , "for playing"
        |> Layout.text
            [ Html.Attributes.style "font-size" "46px"
            , Layout.contentCentered
            ]
    ]
        |> Layout.column
            ([ Html.Attributes.class "dark-background"
             , Html.Style.width "400px"
             , Html.Style.height "400px"
             , Html.Attributes.style "color" "white"
             , Layout.gap 16
             ]
                ++ Layout.centered
            )


menu : List (Attribute msg) -> { frame : Int, onClick : msg } -> Html msg
menu attrs args =
    [ [ Image.image
            [ Image.pixelated
            , Layout.contentCentered
            ]
            { url = "assets/logo.png"
            , width = 39 * 8
            , height = 19 * 8
            }
      , "Tap or press SPACE to start" |> Layout.text [ Html.Attributes.style "font-size" "18px" ]
      ]
        |> Layout.column
            ([ Html.Attributes.style "color" "white"
             , Layout.gap 32
             ]
                ++ Layout.centered
            )

    --, logo args.frame
    ]
        |> Layout.column
            ([ Html.Attributes.class "dark-background"
             , Html.Style.width "400px"
             , Html.Style.height "400px"
             ]
                ++ Layout.asButton
                    { label = "Next Level"
                    , onPress = Just args.onClick
                    }
                ++ attrs
                ++ Layout.centered
            )


viewDoorFloors : String -> Game -> List ( String, Html msg )
viewDoorFloors prefix game =
    let
        attrs x y =
            [ Html.Attributes.style "position" "absolute"
            , Html.Attributes.style "left"
                (String.fromFloat (Config.cellSize * toFloat x) ++ "px")
            , Html.Attributes.style "top"
                (String.fromFloat (Config.cellSize * toFloat y) ++ "px")
            ]
    in
    game.doors
        |> Dict.keys
        |> List.map
            (\( x, y ) ->
                ( prefix ++ "_" ++ String.fromInt x ++ String.fromInt y
                , View.Door.floor (attrs x y)
                )
            )


viewDoors : String -> Game -> List ( String, Html msg )
viewDoors prefix game =
    let
        attrs x y =
            [ Html.Attributes.style "position" "absolute"
            , Html.Attributes.style "left"
                (String.fromFloat (Config.cellSize * toFloat x) ++ "px")
            , Html.Attributes.style "top"
                (String.fromFloat (Config.cellSize * toFloat y) ++ "px")
            ]
    in
    game.doors
        |> Dict.keys
        |> List.map
            (\( x, y ) ->
                ( prefix ++ "_" ++ String.fromInt x ++ String.fromInt y
                , if y == -1 then
                    View.Door.top (attrs x y)

                  else if x == Config.roomSize then
                    View.Door.bottom
                        (Html.Attributes.style "transform" "rotate(-90deg)"
                            :: attrs x y
                        )

                  else if x == -1 then
                    View.Door.bottom
                        (Html.Attributes.style "transform" "rotate(90deg)"
                            :: attrs x y
                        )

                  else
                    View.Door.bottom (attrs x y)
                )
            )


viewFloorAndItems : String -> Game -> List ( String, Html msg )
viewFloorAndItems prefix game =
    Position.asGrid
        { rows = Config.roomSize
        , columns = Config.roomSize
        }
        |> List.map
            (\( x, y ) ->
                ( prefix ++ "_" ++ String.fromInt x ++ "_" ++ String.fromInt y
                , [ case Dict.get ( x, y ) game.floor of
                        Just Ground ->
                            View.Cell.floor
                                [ Html.Style.positionAbsolute
                                , Html.Style.top "0"
                                ]

                        Just Ice ->
                            View.Cell.ice
                                [ Html.Style.positionAbsolute
                                , Html.Style.top "0"
                                ]

                        _ ->
                            case Dict.get ( x, y - 1 ) game.floor of
                                Just Ground ->
                                    View.Cell.holeTop
                                        [ Html.Style.positionAbsolute
                                        , Html.Style.top "0"
                                        ]

                                Just Ice ->
                                    View.Cell.holeTop
                                        [ Html.Style.positionAbsolute
                                        , Html.Style.top "0"
                                        ]

                                _ ->
                                    View.Cell.hole
                                        [ Html.Style.positionAbsolute
                                        , Html.Style.top "0"
                                        ]
                  , case game.floor |> Dict.get ( x, y ) of
                        Just CrateInLava ->
                            View.Cell.crateInLava
                                [ Html.Style.positionAbsolute
                                , Html.Style.top "0"
                                ]

                        _ ->
                            Layout.none
                  , game.items
                        |> Dict.get ( x, y )
                        |> Maybe.map
                            (\item ->
                                View.Cell.item
                                    [ Html.Style.positionAbsolute
                                    , Html.Style.top "0"
                                    ]
                                    item
                            )
                        |> Maybe.withDefault Layout.none
                  , game.particles
                        |> Dict.get ( x, y )
                        |> Maybe.map
                            (\particle ->
                                View.Cell.particle
                                    [ Html.Style.positionAbsolute
                                    , Html.Style.top "0"
                                    ]
                                    particle
                            )
                        |> Maybe.withDefault Layout.none
                  ]
                    ++ (case Dict.get ( x, y ) game.floor of
                            Just Ground ->
                                []

                            Just Ice ->
                                []

                            Just CrateInLava ->
                                View.Cell.borders ( x, y ) game

                            Nothing ->
                                View.Cell.borders ( x, y ) game
                       )
                    |> Html.div
                        [ Html.Style.positionAbsolute
                        , Html.Attributes.style "left"
                            (String.fromFloat (Config.cellSize * toFloat x) ++ "px")
                        , Html.Attributes.style "top"
                            (String.fromFloat (Config.cellSize * toFloat y) ++ "px")
                        ]
                )
            )


viewEntity : String -> { frame : Int } -> Game -> List ( String, Html msg )
viewEntity prefix args game =
    game.cells
        |> Dict.toList
        |> List.map
            (\( ( x, y ), cell ) ->
                ( prefix ++ "_" ++ String.fromInt cell.id
                , View.Cell.toHtml
                    [ Html.Attributes.style "position" "absolute"
                    , Html.Attributes.style "left"
                        (String.fromFloat (Config.cellSize * toFloat x) ++ "px")
                    , Html.Attributes.style "top"
                        (String.fromFloat (Config.cellSize * toFloat y) ++ "px")
                    , Html.Attributes.style "transition" "left 0.2s,top 0.2s"
                    ]
                    { frame = args.frame
                    , playerDirection = game.playerDirection
                    }
                    cell.entity
                )
            )


world :
    { frame : Int
    }
    -> Game
    -> Html msg
world args game =
    viewDoorFloors "0" game
        ++ viewFloorAndItems "1" game
        ++ viewEntity "2" args game
        ++ viewDoors "3" game
        |> List.sortBy Tuple.first
        |> Html.Keyed.node "div"
            [ Html.Attributes.style "position" "relative"
            , Html.Attributes.style "width" (String.fromFloat (Config.cellSize * toFloat Config.roomSize) ++ "px")
            , Html.Attributes.style "height" (String.fromFloat (Config.cellSize * toFloat Config.roomSize) ++ "px")
            , Html.Attributes.style "border" "4px solid white"
            ]

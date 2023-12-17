module Main exposing (main)

import Browser
import Browser.Events
import Cell
    exposing
        ( Cell(..)
        , EnemyType(..)
        , ItemType(..)
        , SolidType(..)
        )
import Component.Map as Map exposing (Actor)
import Config
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Game
import Html exposing (Html)
import Json.Decode as Decode
import PixelEngine exposing (Input(..), game)
import Player exposing (PlayerData)
import Random
import View.Screen as Screen
import View.Tutorial as Tutorial



-------------------------------
-- MODEL
-------------------------------


type GameType
    = Rogue
        { seed : Random.Seed
        , worldSeed : Int
        }
    | Tutorial Int


type alias ModelContent =
    { map : Dict ( Int, Int ) Cell
    , oldScreen : Maybe (Html Msg)
    , player : PlayerData
    , gameType : GameType
    }


type alias Model =
    Maybe ModelContent


type Msg
    = Input Input



-------------------------------
-- CONSTANTS
-------------------------------


worldSize : Int
worldSize =
    Config.mapSize



-------------------------------
-- INIT
-------------------------------


init : flag -> ( Model, Cmd Msg )
init _ =
    ( Nothing
    , Cmd.none
    )



-------------------------------
-- UPDATE
-------------------------------


tutorial : Int -> ModelContent
tutorial num =
    let
        backpackSize : Int
        backpackSize =
            8

        currentMap =
            Cell.tutorial num
                |> Dict.update ( 7, 7 )
                    (always (Just (PlayerCell Down)))
    in
    { map = currentMap
    , oldScreen = Nothing
    , player = Player.init backpackSize
    , gameType =
        Tutorial num
    }


createNewMap : Int -> ModelContent
createNewMap worldSeed =
    let
        backpackSize : Int
        backpackSize =
            8

        ( currentMap, currentSeed ) =
            Random.step
                (Map.generator worldSize Cell.generator)
                (Random.initialSeed worldSeed)
                |> Tuple.mapFirst
                    (Dict.update ( 3, 3 ) <| always <| Just <| PlayerCell Down)
    in
    { map = currentMap
    , oldScreen = Nothing
    , player = Player.init backpackSize
    , gameType =
        Rogue
            { worldSeed = worldSeed
            , seed = currentSeed
            }
    }


nextLevel : ModelContent -> ( Model, Cmd Msg )
nextLevel { gameType, map, player } =
    case gameType of
        Rogue { worldSeed } ->
            ( Just
                (createNewMap (worldSeed + 7)
                    |> (\newModel ->
                            { newModel
                                | oldScreen = Just (Screen.world worldSeed map player [])
                            }
                       )
                )
            , Cmd.none
            )

        Tutorial num ->
            if num == 5 then
                ( Nothing
                , Cmd.none
                )

            else
                ( Just
                    (tutorial (num + 1)
                        |> (\newModel ->
                                { newModel
                                    | oldScreen = Just (Screen.world num map player [])
                                }
                           )
                    )
                , Cmd.none
                )


updateGame : (Player.Game -> Player.Game) -> ModelContent -> ( Model, Cmd Msg )
updateGame fun ({ player, map } as modelContent) =
    ( player, map )
        |> fun
        |> (\( playerData, newMap ) ->
                ( Just
                    { modelContent
                        | player = playerData
                        , map = newMap
                        , oldScreen = Nothing
                    }
                , Cmd.none
                )
           )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        Just ({ map, gameType } as modelContent) ->
            if
                Dict.filter
                    (\_ cell ->
                        case cell of
                            EnemyCell _ _ ->
                                True

                            _ ->
                                False
                    )
                    map
                    |> Dict.isEmpty
            then
                nextLevel modelContent

            else
                case msg of
                    Input input ->
                        let
                            maybePlayer : Dict ( Int, Int ) Cell -> Maybe Actor
                            maybePlayer currentMap =
                                currentMap
                                    |> Dict.toList
                                    |> List.filter
                                        (\( _, cell ) ->
                                            case cell of
                                                PlayerCell _ ->
                                                    True

                                                _ ->
                                                    False
                                        )
                                    |> List.head
                                    |> Maybe.andThen
                                        (\( key, cell ) ->
                                            case cell of
                                                PlayerCell dir ->
                                                    Just ( key, dir )

                                                _ ->
                                                    Nothing
                                        )
                        in
                        case maybePlayer map of
                            Just playerCell ->
                                let
                                    updateDirection dir game =
                                        ( playerCell, game )
                                            |> Game.applyDirection (worldSize - 1) dir
                                            |> Tuple.second
                                in
                                case input of
                                    InputA ->
                                        modelContent
                                            |> updateGame (Player.activate playerCell)

                                    InputUp ->
                                        modelContent
                                            |> updateGame (updateDirection Up)

                                    InputLeft ->
                                        modelContent
                                            |> updateGame (updateDirection Left)

                                    InputDown ->
                                        modelContent
                                            |> updateGame (updateDirection Down)

                                    InputRight ->
                                        modelContent
                                            |> updateGame (updateDirection Right)

                                    InputX ->
                                        modelContent
                                            |> updateGame (Tuple.mapFirst Player.rotateLeft)

                                    InputY ->
                                        modelContent
                                            |> updateGame (Tuple.mapFirst Player.rotateRight)

                                    InputB ->
                                        ( Nothing
                                        , Cmd.none
                                        )

                            Nothing ->
                                case gameType of
                                    Rogue { worldSeed } ->
                                        ( Just
                                            (createNewMap (worldSeed - 2)
                                                |> (\newModel ->
                                                        { newModel
                                                            | oldScreen = Just Screen.death
                                                        }
                                                   )
                                            )
                                        , Cmd.none
                                        )

                                    Tutorial num ->
                                        ( Just
                                            (tutorial num
                                                |> (\newModel ->
                                                        { newModel
                                                            | oldScreen = Just Screen.death
                                                        }
                                                   )
                                            )
                                        , Cmd.none
                                        )

        Nothing ->
            case msg of
                Input InputLeft ->
                    ( Just
                        (createNewMap 1
                            |> (\newModel ->
                                    { newModel
                                        | oldScreen = Just Screen.menu
                                    }
                               )
                        )
                    , Cmd.none
                    )

                Input InputRight ->
                    ( Just
                        (createNewMap 1
                            |> (\newModel ->
                                    { newModel
                                        | oldScreen = Just Screen.menu
                                    }
                               )
                        )
                    , Cmd.none
                    )

                Input InputUp ->
                    ( Just
                        (tutorial 1
                            |> (\newModel ->
                                    { newModel
                                        | oldScreen = Just Screen.menu
                                    }
                               )
                        )
                    , Cmd.none
                    )

                Input InputDown ->
                    ( Just
                        (tutorial 1
                            |> (\newModel ->
                                    { newModel
                                        | oldScreen = Just Screen.menu
                                    }
                               )
                        )
                    , Cmd.none
                    )

                _ ->
                    ( model
                    , Cmd.none
                    )



-------------------------------
-- SUBSCRIPTIONS
-------------------------------


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.map toDirection (Decode.field "key" Decode.string)


toDirection : String -> Msg
toDirection string =
    case string of
        "a" ->
            Input InputLeft

        "d" ->
            Input InputRight

        "w" ->
            Input InputUp

        "s" ->
            Input InputDown

        "q" ->
            Input InputX

        "e" ->
            Input InputY

        " " ->
            Input InputA

        _ ->
            Input InputB


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyDown keyDecoder



-------------------------------
-- VIEW
-------------------------------


viewRogue : ModelContent -> Int -> Html Msg
viewRogue { oldScreen, player, map } worldSeed =
    case oldScreen of
        Just _ ->
            Screen.world worldSeed map player []

        Nothing ->
            if player.lifes > 0 then
                Screen.world worldSeed map player []

            else
                Screen.death


view : Model -> Html Msg
view model =
    let
        body =
            case model of
                Just ({ gameType, oldScreen, player, map } as modelContent) ->
                    case gameType of
                        Rogue { worldSeed } ->
                            viewRogue modelContent worldSeed

                        Tutorial num ->
                            Tutorial.view oldScreen player map num

                Nothing ->
                    Screen.menu
    in
    body



-------------------------------
-- MAIN
-------------------------------


main : Program {} Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

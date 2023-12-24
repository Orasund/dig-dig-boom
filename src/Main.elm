module Main exposing (main)

import Browser
import Browser.Events
import Cell
    exposing
        ( Cell(..)
        , EnemyType(..)
        )
import Config
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Game exposing (Game)
import Game.Generate
import Game.Update
import Html exposing (Html)
import Input exposing (Input(..))
import Json.Decode as Decode
import Random exposing (Seed)
import Time
import View.Screen as Screen
import View.Stylesheet



-------------------------------
-- MODEL
-------------------------------


type Overlay
    = Menu


type alias ModelContent =
    { game : Game
    , score : Int
    , levelSeed : Seed
    , seed : Seed
    , overlay : Maybe Overlay
    , frame : Int
    }


type alias Model =
    ModelContent


type Msg
    = Input Input
    | GotSeed Seed
    | NextFrameRequested
    | NoOps



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
    let
        ( game, seed ) =
            Random.step Game.Generate.new
                (Random.initialSeed 42)
    in
    ( { levelSeed = seed
      , seed = seed
      , game = game
      , overlay = Just Menu
      , score = 0
      , frame = 0
      }
    , Random.generate GotSeed Random.independentSeed
    )



-------------------------------
-- UPDATE
-------------------------------


nextLevel : Model -> Model
nextLevel model =
    let
        ( game, seed ) =
            Random.step Game.Generate.new model.seed
    in
    { model
        | levelSeed = model.seed
        , seed = seed
        , game = game
        , overlay = Nothing
    }


gameWon : ModelContent -> ( Model, Cmd Msg )
gameWon model =
    ( { model
        | score = model.score + 1
      }
        |> nextLevel
    , Cmd.none
    )


gameLost : ModelContent -> ( Model, Cmd Msg )
gameLost model =
    ( { model | seed = model.levelSeed }
        |> nextLevel
    , Cmd.none
    )


setGame : Model -> Game -> Model
setGame model game =
    { model
        | game = game
    }


gotSeed : Seed -> Model -> Model
gotSeed seed model =
    { model | seed = seed }


nextFrameRequested : Model -> Model
nextFrameRequested model =
    { model | frame = model.frame + 1 |> modBy 2 }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            case model.overlay of
                Just Menu ->
                    ( nextLevel model
                    , Cmd.none
                    )

                Nothing ->
                    if
                        Dict.filter
                            (\_ cell ->
                                case cell of
                                    EnemyCell _ _ ->
                                        True

                                    _ ->
                                        False
                            )
                            model.game.cells
                            |> Dict.isEmpty
                    then
                        gameWon model

                    else
                        let
                            maybePlayerPosition : Dict ( Int, Int ) Cell -> Maybe ( ( Int, Int ), Direction )
                            maybePlayerPosition currentMap =
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
                        case maybePlayerPosition model.game.cells of
                            Just ( playerPosition, playerDirection ) ->
                                let
                                    updateDirection dir game =
                                        Game.Update.movePlayerInDirectionAndUpdateGame (worldSize - 1)
                                            dir
                                            playerPosition
                                            game
                                in
                                case input of
                                    InputA ->
                                        ( model.game
                                            |> Game.Update.placeBombe ( playerPosition, playerDirection )
                                            |> Maybe.withDefault model.game
                                            |> setGame model
                                        , Cmd.none
                                        )

                                    InputUp ->
                                        ( model.game
                                            |> updateDirection Up
                                            |> setGame model
                                        , Cmd.none
                                        )

                                    InputLeft ->
                                        ( model.game
                                            |> updateDirection Left
                                            |> setGame model
                                        , Cmd.none
                                        )

                                    InputDown ->
                                        ( model.game
                                            |> updateDirection Down
                                            |> setGame model
                                        , Cmd.none
                                        )

                                    InputRight ->
                                        ( model.game
                                            |> updateDirection Right
                                            |> setGame model
                                        , Cmd.none
                                        )

                            Nothing ->
                                gameLost model

        NextFrameRequested ->
            ( nextFrameRequested model
            , Cmd.none
            )

        GotSeed seed ->
            ( gotSeed seed model, Cmd.none )

        NoOps ->
            ( model, Cmd.none )



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

        " " ->
            Input InputA

        _ ->
            NoOps


subscriptions : Model -> Sub Msg
subscriptions _ =
    [ Browser.Events.onKeyDown keyDecoder
    , Time.every 500 (\_ -> NextFrameRequested)
    ]
        |> Sub.batch



-------------------------------
-- VIEW
-------------------------------


viewGame : Model -> Html Msg
viewGame model =
    if model.game.player.lifes > 0 then
        Screen.world
            { score = model.score
            , onInput = Input
            , frame = model.frame
            }
            model.game

    else
        Screen.death { onClick = Input InputA }


view : Model -> Html Msg
view model =
    [ View.Stylesheet.toHtml
    , case model.overlay of
        Nothing ->
            viewGame model

        Just Menu ->
            Screen.menu
                { frame = model.frame
                , onClick = Input InputA
                }
    ]
        |> Html.div []



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

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
import Component.Map exposing (Actor)
import Config
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Game
import Game.Generate
import Html exposing (Html)
import Html.Attributes
import Json.Decode as Decode
import Layout
import PixelEngine exposing (Input(..), game)
import Player exposing (Game)
import Random exposing (Seed)
import Time
import View.Screen as Screen
import View.Stylesheet
import View.Transition exposing (nextLevel)



-------------------------------
-- MODEL
-------------------------------


type Overlay
    = Menu


type alias ModelContent =
    { game : Game
    , score : Int
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
    ( { seed = seed
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
        | seed = seed
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
    ( model |> nextLevel
    , Cmd.none
    )


updateGame : (Player.Game -> Player.Game) -> ModelContent -> ( Model, Cmd Msg )
updateGame fun ({ game } as modelContent) =
    ( { modelContent
        | game = fun game
      }
    , Cmd.none
    )


gotSeed : Seed -> Model -> Model
gotSeed seed model =
    { model | seed = seed }


nextFrameRequested : Model -> Model
nextFrameRequested model =
    { model | frame = model.frame + 1 |> modBy 2 }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model.overlay of
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
                        case maybePlayer model.game.cells of
                            Just playerCell ->
                                let
                                    updateDirection dir game =
                                        ( playerCell, game )
                                            |> Game.applyDirection (worldSize - 1) dir
                                            |> Tuple.second
                                in
                                case input of
                                    InputA ->
                                        model
                                            |> updateGame
                                                (\game ->
                                                    game
                                                        |> Player.placeBombe playerCell
                                                        |> Maybe.withDefault game
                                                )

                                    InputUp ->
                                        model
                                            |> updateGame (updateDirection Up)

                                    InputLeft ->
                                        model
                                            |> updateGame (updateDirection Left)

                                    InputDown ->
                                        model
                                            |> updateGame (updateDirection Down)

                                    InputRight ->
                                        model
                                            |> updateGame (updateDirection Right)

                                    InputX ->
                                        ( model
                                        , Cmd.none
                                        )

                                    InputY ->
                                        ( model
                                        , Cmd.none
                                        )

                                    InputB ->
                                        ( model
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

        Just Menu ->
            updateMenu msg model


updateMenu : Msg -> Model -> ( Model, Cmd Msg )
updateMenu msg model =
    case msg of
        Input _ ->
            ( nextLevel model
            , Cmd.none
            )

        NextFrameRequested ->
            ( nextFrameRequested model
            , Cmd.none
            )

        GotSeed seed ->
            ( gotSeed seed model
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
        Screen.world { score = model.score, onInput = Input } model.game []

    else
        Screen.death


view : Model -> Html Msg
view model =
    [ View.Stylesheet.toHtml
    , case model.overlay of
        Nothing ->
            viewGame model

        Just Menu ->
            Screen.menu
                { frame = model.frame }
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

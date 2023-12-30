module Main exposing (main)

import Browser
import Browser.Events
import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..))
import Game exposing (Game)
import Game.Level exposing (Level)
import Game.Update
import Html exposing (Html)
import Html.Style
import Input exposing (Input(..))
import Json.Decode as Decode
import Layout
import Random exposing (Seed)
import Time
import View.Screen as Screen
import View.Stylesheet
import View.World
import World exposing (Node(..), World)



-------------------------------
-- MODEL
-------------------------------


type Overlay
    = Menu
    | WorldMap


type alias Model =
    { game : Game
    , levelSeed : Seed
    , seed : Seed
    , overlay : Maybe Overlay
    , frame : Int
    , history : List Game
    , level : Level
    , world : World
    }


type Msg
    = Input Input
    | GotSeed Seed
    | NextFrameRequested
    | NoOps



-------------------------------
-- INIT
-------------------------------


init : flag -> ( Model, Cmd Msg )
init _ =
    let
        level =
            Game.Level.first

        ( game, seed ) =
            Random.step (Game.Level.generate level)
                (Random.initialSeed 42)
    in
    ( { levelSeed = seed
      , seed = seed
      , game = game
      , overlay = Just WorldMap --Just Menu
      , frame = 0
      , history = []
      , level = level
      , world = World.new seed
      }
    , Random.generate GotSeed Random.independentSeed
    )



-------------------------------
-- UPDATE
-------------------------------


generateLevel : Seed -> Level -> Model -> Model
generateLevel seed level model =
    let
        ( game, _ ) =
            Random.step (Game.Level.generate level) seed
    in
    { model
        | levelSeed = seed
        , game = { game | bombs = model.game.bombs, lifes = model.game.lifes }
        , level = level
        , overlay = Nothing
    }


gameWon : Model -> ( Model, Cmd Msg )
gameWon model =
    Random.step (World.solveRoom model.world) model.seed
        |> (\( world, seed ) ->
                ( { model | world = world, seed = seed, overlay = Just WorldMap, history = [] }
                , Cmd.none
                )
           )


gameLost : Model -> ( Model, Cmd Msg )
gameLost model =
    ( { model
        | game = model.game |> (\game -> { game | lifes = 1, bombs = 0 })
        , history = []
      }
        |> generateLevel model.levelSeed model.level
    , Cmd.none
    )


setGame : Model -> Game -> Model
setGame model game =
    { model
        | game = game
        , history = model.game :: model.history
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
                Just WorldMap ->
                    updateWorldMap input model

                Just Menu ->
                    ( generateLevel model.seed model.level model
                    , Cmd.none
                    )

                Nothing ->
                    if Game.isWon model.game then
                        gameWon model

                    else
                        case Game.getPlayerPosition model.game of
                            Just playerPosition ->
                                let
                                    updateDirection dir game =
                                        Game.Update.movePlayerInDirectionAndUpdateGame
                                            dir
                                            playerPosition
                                            game
                                in
                                case input of
                                    InputActivate ->
                                        ( model.game
                                            |> Game.Update.placeBombeAndUpdateGame playerPosition
                                            |> Maybe.withDefault model.game
                                            |> setGame model
                                        , Cmd.none
                                        )

                                    InputDir dir ->
                                        ( model.game
                                            |> updateDirection dir
                                            |> setGame model
                                        , Cmd.none
                                        )

                                    InputUndo ->
                                        case model.history of
                                            head :: tail ->
                                                ( { model | game = head, history = tail }
                                                , Cmd.none
                                                )

                                            [] ->
                                                ( model, Cmd.none )

                            Nothing ->
                                case input of
                                    InputUndo ->
                                        case model.history of
                                            head :: tail ->
                                                ( { model | game = head, history = tail }
                                                , Cmd.none
                                                )

                                            [] ->
                                                ( model, Cmd.none )

                                    _ ->
                                        gameLost model

        NextFrameRequested ->
            ( nextFrameRequested model
            , Cmd.none
            )

        GotSeed seed ->
            ( gotSeed seed model, Cmd.none )

        NoOps ->
            ( model, Cmd.none )


updateWorldMap : Input -> Model -> ( Model, Cmd Msg )
updateWorldMap input model =
    case input of
        InputActivate ->
            case model.world.nodes |> Dict.get model.world.player of
                Just (Room { level, seed }) ->
                    ( generateLevel seed level model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        InputDir dir ->
            ( World.move dir model.world
                |> Maybe.map (\world -> { model | world = world })
                |> Maybe.withDefault model
            , Cmd.none
            )

        _ ->
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
            Input (InputDir Left)

        "d" ->
            Input (InputDir Right)

        "w" ->
            Input (InputDir Up)

        "s" ->
            Input (InputDir Down)

        "r" ->
            Input InputUndo

        " " ->
            Input InputActivate

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


view : Model -> Html Msg
view model =
    [ View.Stylesheet.toHtml
    , [ Screen.world
            { onInput = Input
            , frame = model.frame
            }
            model.game
      , case model.overlay of
            Nothing ->
                if model.game.lifes > 0 then
                    Layout.none

                else
                    Screen.death
                        [ Html.Style.positionAbsolute
                        , Html.Style.top "0"
                        ]
                        { onClick = Input InputActivate }

            Just WorldMap ->
                View.World.toHtml
                    [ Html.Style.positionAbsolute
                    , Html.Style.top "0"
                    ]
                    model.world

            Just Menu ->
                Screen.menu
                    [ Html.Style.positionAbsolute
                    , Html.Style.top "0"
                    ]
                    { frame = model.frame
                    , onClick = Input InputActivate
                    }
      ]
        |> Html.div
            [ Html.Style.positionRelative
            ]
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

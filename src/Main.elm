module Main exposing (main)

import Browser
import Browser.Events
import Config
import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item)
import Game exposing (Game)
import Game.Event exposing (GameAndKill)
import Game.Update
import Html exposing (Html)
import Html.Attributes
import Input exposing (Input(..))
import Json.Decode as Decode
import Layout
import Process
import Random exposing (Seed)
import Task
import Time
import View.Controls
import View.Screen as Screen
import View.Stylesheet
import View.World
import World exposing (Node(..), RoomSort(..), World)
import World.Level
import World.Trial



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
    , room : RoomSort
    , world : World
    , initialItem : Maybe Item
    }


type Msg
    = Input Input
    | ApplyKills (List ( Int, Int ))
    | GotSeed Seed
    | NextFrameRequested
    | NoOps



-------------------------------
-- INIT
-------------------------------


init : flag -> ( Model, Cmd Msg )
init _ =
    let
        room =
            Trial 0

        level =
            World.Trial.fromInt 0 |> Maybe.withDefault World.Level.empty

        ( game, seed ) =
            Random.step level (Random.initialSeed 42)
    in
    ( { levelSeed = seed
      , seed = seed
      , game = game
      , initialItem = Nothing
      , overlay = Just Menu
      , frame = 0
      , history = []
      , room = room
      , world = World.new seed
      }
    , Random.generate GotSeed Random.independentSeed
    )



-------------------------------
-- UPDATE
-------------------------------


generateLevel : Seed -> RoomSort -> Model -> Model
generateLevel seed sort model =
    let
        ( game, _ ) =
            case sort of
                Stage level ->
                    Random.step (World.Level.generate level.difficulty) seed

                Trial i ->
                    Random.step
                        (World.Trial.fromInt i
                            |> Maybe.withDefault World.Level.empty
                        )
                        seed
    in
    { model
        | levelSeed = seed
        , game = { game | item = model.game.item }
        , room = sort
        , overlay = Nothing
    }


solvedRoom : Model -> ( Model, Cmd Msg )
solvedRoom model =
    Random.step (World.solveRoom model.world) model.seed
        |> (\( world, seed ) ->
                ( { model
                    | world = world
                    , seed = seed
                    , overlay = Just WorldMap
                    , history = []
                    , initialItem = model.game.item
                  }
                , Cmd.none
                )
           )


restartRoom : Model -> ( Model, Cmd Msg )
restartRoom model =
    ( { model
        | game =
            model.game
                |> (\game ->
                        { game
                            | item = model.initialItem
                        }
                   )
        , history = []
      }
        |> generateLevel model.levelSeed model.room
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


applyGameAndKill : Model -> GameAndKill -> ( Model, Cmd Msg )
applyGameAndKill model output =
    ( setGame model output.game
    , Process.sleep 100
        |> Task.perform (\() -> ApplyKills output.kill)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            case model.overlay of
                Just WorldMap ->
                    updateWorldMap input model

                Just Menu ->
                    ( generateLevel model.seed model.room model
                    , Cmd.none
                    )

                Nothing ->
                    if Game.isWon model.game then
                        solvedRoom model

                    else
                        case input of
                            InputActivate ->
                                model.game
                                    |> Game.getPlayerPosition
                                    |> Maybe.andThen
                                        (\playerPosition ->
                                            model.game
                                                |> Game.Update.placeBombeAndUpdateGame playerPosition
                                                |> Maybe.map (applyGameAndKill model)
                                        )
                                    |> Maybe.withDefault ( model, Cmd.none )

                            InputDir dir ->
                                model.game
                                    |> Game.getPlayerPosition
                                    |> Maybe.map
                                        (\playerPosition ->
                                            model.game
                                                |> Game.Update.movePlayerInDirectionAndUpdateGame
                                                    dir
                                                    playerPosition
                                                |> applyGameAndKill model
                                        )
                                    |> Maybe.withDefault ( model, Cmd.none )

                            InputUndo ->
                                case model.history of
                                    head :: tail ->
                                        ( { model | game = head, history = tail }
                                        , Cmd.none
                                        )

                                    [] ->
                                        ( model, Cmd.none )

                            InputReset ->
                                model
                                    |> restartRoom

                            InputOpenMap ->
                                ( { model | overlay = Just WorldMap }, Cmd.none )

        ApplyKills kills ->
            ( { model | game = Game.Event.apply kills model.game }
            , Cmd.none
            )

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
                Just (Room { sort, seed }) ->
                    {--seed
                        |> Random.step (World.solveRoom model.world)
                        |> (\( w, s ) -> ( { model | world = w, seed = s }, Cmd.none ))
                    --}
                    ( generateLevel seed sort model, Cmd.none )

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

        "c" ->
            Input InputReset

        "Escape" ->
            Input InputOpenMap

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
    , [ (case model.overlay of
            Nothing ->
                Screen.world
                    { frame = model.frame
                    }
                    model.game

            Just WorldMap ->
                View.World.toHtml []
                    model.world

            Just Menu ->
                Screen.menu []
                    { frame = model.frame
                    , onClick = Input InputActivate
                    }
        )
            |> Layout.el
                ([ Html.Attributes.style "width" "400px"
                 , Html.Attributes.style "height" "400px"
                 ]
                    ++ Layout.centered
                )
      , View.Controls.toHtml
            { onInput = Input
            , item = model.game.item
            , isLevelSelect = model.overlay /= Nothing
            }
      ]
        |> Layout.column
            ([ Html.Attributes.style "width" "400px"
             , Html.Attributes.style "padding" (String.fromInt Config.cellSize ++ "px 0")
             , Layout.gap 16
             ]
                ++ Layout.centered
            )
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

module Main exposing (main)

import Browser
import Browser.Events
import Config
import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..), Item)
import Game exposing (Game)
import Game.Event exposing (Event(..), GameAndEvents)
import Game.Update
import Gen.Sound as Sound exposing (Sound(..))
import Html exposing (Html)
import Html.Attributes
import Input exposing (Input(..))
import Json.Decode as Decode
import Layout
import Platform.Cmd as Cmd
import Port
import PortDefinition exposing (FromElm(..), ToElm(..))
import Process
import Random exposing (Seed)
import Task
import Time
import View.Controls
import View.Screen as Screen
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
    | GameWon


type alias Model =
    { game : Game
    , levelSeed : Seed
    , seed : Seed
    , overlay : Maybe Overlay
    , frame : Int
    , history : List Game
    , room : Int
    , world : World
    , initialItem : Maybe Item
    }


type Msg
    = Input Input
    | ApplyEvents (List Event)
    | GotSeed Seed
    | NextFrameRequested
    | NoOps
    | NextLevelRequested
    | Received (Result Decode.Error PortDefinition.ToElm)



-------------------------------
-- INIT
-------------------------------


init : flag -> ( Model, Cmd Msg )
init _ =
    let
        room =
            0

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
    , Cmd.batch
        [ Port.fromElm (RegisterSounds Sound.asList)
        , Random.generate GotSeed Random.independentSeed
        ]
    )



-------------------------------
-- UPDATE
-------------------------------


generateLevel : Seed -> Int -> Model -> Model
generateLevel seed trial model =
    let
        maybeGenerator =
            case Trial trial of
                Stage level ->
                    World.Level.generate level.difficulty |> Just

                Trial i ->
                    World.Trial.fromInt i
    in
    maybeGenerator
        |> Maybe.map (\generator -> Random.step generator seed)
        |> Maybe.map
            (\( game, _ ) ->
                { model
                    | levelSeed = seed
                    , game = { game | item = model.game.item }
                    , room = trial
                    , overlay = Nothing
                }
            )
        |> Maybe.withDefault { model | overlay = Just GameWon }


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
    , PlaySound { sound = Retry, looping = False } |> Port.fromElm
    )


nextRoom : Model -> ( Model, Cmd Msg )
nextRoom model =
    ( generateLevel model.seed
        (model.room + 1)
        { model
            | room = model.room + 1
            , history = []
        }
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


applyGameAndKill : Model -> GameAndEvents -> ( Model, Cmd Msg )
applyGameAndKill model output =
    ( setGame model output.game
    , Process.sleep 100
        |> Task.perform (\() -> ApplyEvents output.kill)
    )


applyEvent : Event -> Model -> ( Model, Cmd Msg )
applyEvent event model =
    case event of
        Kill pos ->
            ( { model | game = Game.Event.kill pos model.game }
            , Cmd.none
            )

        Fx sound ->
            ( model
            , Port.fromElm
                (PlaySound
                    { sound = sound
                    , looping = False
                    }
                )
            )

        StageComplete ->
            ( model
            , Cmd.batch
                [ Process.sleep 200 |> Task.perform (\() -> NextLevelRequested)
                , PlaySound
                    { sound = Win
                    , looping = False
                    }
                    |> Port.fromElm
                ]
            )


applyEvents : List Event -> Model -> ( Model, Cmd Msg )
applyEvents events model =
    events
        |> List.foldl
            (\event ( m, c1 ) ->
                applyEvent event m
                    |> Tuple.mapSecond
                        (\c2 ->
                            Cmd.batch [ c1, c2 ]
                        )
            )
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            case model.overlay of
                Just GameWon ->
                    ( model, Cmd.none )

                Just WorldMap ->
                    updateWorldMap input model

                Just Menu ->
                    ( generateLevel model.seed model.room model
                    , Cmd.none
                    )

                Nothing ->
                    if Game.isWon model.game then
                        --solvedRoom model
                        ( model, Cmd.none )

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
                                    |> Maybe.andThen
                                        (\playerPosition ->
                                            model.game
                                                |> Game.Update.movePlayerInDirectionAndUpdateGame
                                                    dir
                                                    playerPosition
                                                |> Maybe.map
                                                    (Game.Event.andThen
                                                        (\m -> { game = m, kill = [ Fx Move ] })
                                                    )
                                                |> Maybe.map (applyGameAndKill model)
                                        )
                                    |> Maybe.withDefault ( model, Cmd.none )

                            InputUndo ->
                                case model.history of
                                    head :: tail ->
                                        ( { model | game = head, history = tail }
                                        , PlaySound { sound = Undo, looping = False } |> Port.fromElm
                                        )

                                    [] ->
                                        ( model, Cmd.none )

                            InputReset ->
                                model
                                    |> restartRoom

                            InputOpenMap ->
                                ( { model | overlay = Just WorldMap }, Cmd.none )

        ApplyEvents events ->
            model
                |> applyEvents
                    (if Game.isWon model.game then
                        StageComplete :: events

                     else
                        events
                    )

        NextFrameRequested ->
            ( nextFrameRequested model
            , Cmd.none
            )

        GotSeed seed ->
            ( gotSeed seed model, Cmd.none )

        NoOps ->
            ( model, Cmd.none )

        NextLevelRequested ->
            nextRoom model

        Received result ->
            case result of
                Ok (SoundEnded sound) ->
                    ( model, Cmd.none )

                _ ->
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
                    ( generateLevel seed model.room model, Cmd.none )

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

        -- "Escape" ->
        --    Input InputOpenMap
        --" " ->
        --    Input InputActivate
        _ ->
            NoOps


subscriptions : Model -> Sub Msg
subscriptions _ =
    [ Browser.Events.onKeyDown keyDecoder
    , Time.every 500 (\_ -> NextFrameRequested)
    , Port.toElm |> Sub.map Received
    ]
        |> Sub.batch



-------------------------------
-- VIEW
-------------------------------


view : Model -> Html Msg
view model =
    [ [ (case model.overlay of
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

            Just GameWon ->
                Screen.gameWon
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

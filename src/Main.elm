module Main exposing (main)

import Browser
import Browser.Events
import Dict
import Direction exposing (Direction(..))
import Entity exposing (Enemy(..), Entity(..))
import Game exposing (Game)
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
        room =
            TrialRoom 0

        level =
            World.Trial.fromInt 0 |> Maybe.withDefault World.Level.empty

        ( game, seed ) =
            Random.step level (Random.initialSeed 42)
    in
    ( { levelSeed = seed
      , seed = seed
      , game = game
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
                LevelRoom level ->
                    Random.step (World.Level.generate level) seed

                TrialRoom i ->
                    Random.step
                        (World.Trial.fromInt i
                            |> Maybe.withDefault World.Level.empty
                        )
                        seed
    in
    { model
        | levelSeed = seed
        , game = { game | bombs = model.game.bombs, lifes = model.game.lifes }
        , room = sort
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
                Just (Room { sort, seed }) ->
                    seed
                        |> Random.step (World.solveRoom model.world)
                        |> (\( w, s ) -> ( { model | world = w, seed = s }, Cmd.none ))

                --( generateLevel seed sort model, Cmd.none )
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

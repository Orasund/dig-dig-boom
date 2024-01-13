module Game exposing (Cell, Game, addFloor, addItem, addPlayer, clearParticles, empty, face, findFirstEmptyCellInDirection, findFirstInDirection, fromCells, get, getPlayerPosition, insert, isLost, isWon, move, placeItem, remove, removeFloor, removeItem, update)

import Config
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Entity
    exposing
        ( Enemy(..)
        , Entity(..)
        , Floor(..)
        , Item(..)
        , ParticleSort(..)
        )
import Math
import Position


type alias Cell =
    { id : Int
    , entity : Entity
    }


type alias Game =
    { cells : Dict ( Int, Int ) Cell
    , items : Dict ( Int, Int ) Item
    , particles : Dict ( Int, Int ) ParticleSort
    , floor : Dict ( Int, Int ) Floor
    , nextId : Int
    , item : Maybe Item
    , playerDirection : Direction
    , playerPos : Maybe ( Int, Int )
    , doors : Dict ( Int, Int ) { room : ( Int, Int ) }
    , won : Bool
    }


addPlayer : ( Int, Int ) -> Game -> Game
addPlayer ( x, y ) game =
    { game
        | playerPos = Just ( x, y )
        , playerDirection =
            if x == 0 then
                Right

            else if x == Config.roomSize - 1 then
                Left

            else if y == 0 then
                Down

            else
                Up
    }
        |> insert ( x, y ) Player


clearParticles : Game -> Game
clearParticles game =
    { game | particles = Dict.empty }


fromCells : Dict ( Int, Int ) Entity -> Dict ( Int, Int ) Item -> Game
fromCells cells items =
    { empty
        | cells =
            cells
                |> Dict.toList
                |> List.indexedMap
                    (\i ( pos, entity ) ->
                        ( pos
                        , { id = i
                          , entity = entity
                          }
                        )
                    )
                |> Dict.fromList
        , items = items
        , nextId = Dict.size cells
    }


empty : Game
empty =
    { cells = Dict.empty
    , items = Dict.empty
    , particles = Dict.empty
    , floor =
        Position.asGrid
            { columns = Config.roomSize
            , rows = Config.roomSize
            }
            |> List.map (\pos -> Tuple.pair pos Ground)
            |> Dict.fromList
    , item = Nothing
    , nextId = 0
    , playerDirection = Down
    , playerPos = Nothing
    , won = False
    , doors = Dict.empty
    }


isWon : Game -> Bool
isWon game =
    game.won


isLost : Game -> Bool
isLost game =
    getPlayerPosition game == Nothing


get : ( Int, Int ) -> Game -> Maybe Entity
get pos game =
    game.cells |> Dict.get pos |> Maybe.map .entity


remove : ( Int, Int ) -> Game -> Game
remove pos game =
    { game
        | cells = game.cells |> Dict.remove pos
        , playerPos =
            if game.playerPos == Just pos then
                Nothing

            else
                game.playerPos
    }


insert : ( Int, Int ) -> Entity -> Game -> Game
insert pos entity game =
    { game
        | cells =
            game.cells
                |> Dict.insert pos
                    { id = game.nextId
                    , entity = entity
                    }
        , nextId = game.nextId + 1
    }


placeItem : ( Int, Int ) -> Item -> Game -> Game
placeItem pos item game =
    { game | items = game.items |> Dict.insert pos item }


addFloor : ( Int, Int ) -> Floor -> Game -> Game
addFloor pos floor game =
    { game | floor = game.floor |> Dict.insert pos floor }


removeFloor : ( Int, Int ) -> Game -> Game
removeFloor pos game =
    { game | floor = game.floor |> Dict.remove pos }


update : ( Int, Int ) -> (Entity -> Entity) -> Game -> Game
update pos fun game =
    { game
        | cells =
            game.cells
                |> Dict.update pos
                    (Maybe.map (\cell -> { cell | entity = fun cell.entity }))
    }


move : { from : ( Int, Int ), to : ( Int, Int ) } -> Game -> Maybe Game
move args game =
    if Math.posIsValid args.to && (Dict.member args.to game.cells |> not) then
        game.cells
            |> Dict.get args.from
            |> Maybe.map
                (\a ->
                    game.cells
                        |> Dict.insert args.to a
                        |> Dict.remove args.from
                        |> (\cells ->
                                { game
                                    | cells = cells
                                    , playerPos =
                                        if Just args.from == game.playerPos then
                                            Just args.to

                                        else
                                            game.playerPos
                                }
                           )
                )

    else
        Nothing


findFirstInDirection : ( Int, Int ) -> Direction -> Game -> Maybe Entity
findFirstInDirection position direction game =
    let
        newPos =
            Direction.toVector direction
                |> Position.addToVector position
    in
    if Math.posIsValid newPos then
        case Dict.get newPos game.cells of
            Nothing ->
                findFirstInDirection newPos
                    direction
                    game

            Just a ->
                Just a.entity

    else
        Nothing


getPlayerPosition : Game -> Maybe ( Int, Int )
getPlayerPosition game =
    game.playerPos


findFirstEmptyCellInDirection : ( Int, Int ) -> Direction -> Game -> ( Int, Int )
findFirstEmptyCellInDirection pos direction game =
    let
        newPos : ( Int, Int )
        newPos =
            direction
                |> Direction.toVector
                |> Position.addToVector pos
    in
    if Math.posIsValid newPos then
        case get newPos game of
            Just _ ->
                pos

            Nothing ->
                findFirstEmptyCellInDirection newPos direction game

    else
        pos


face :
    Direction
    -> Game
    -> Game
face direction game =
    { game | playerDirection = direction }


removeItem : Game -> Game
removeItem game =
    { game | item = Nothing }


addItem : Item -> Game -> Maybe Game
addItem item game =
    if game.item == Nothing then
        { game | item = Just item } |> Just

    else
        Nothing

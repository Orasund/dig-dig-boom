module Game exposing (Cell, Game, addFloor, addItem, clearParticles, empty, face, findFirstEmptyCellInDirection, findFirstInDirection, fromCells, get, getPlayerPosition, insert, isLost, isWon, move, placeItem, remove, removeFloor, removeItem, update)

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
    , doors : Dict ( Int, Int ) Int
    , won : Bool
    }


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
    { game | cells = game.cells |> Dict.remove pos }


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


addFloor : ( Int, Int ) -> Game -> Game
addFloor pos game =
    { game | floor = game.floor |> Dict.insert pos Ground }


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
    game.cells
        |> Dict.toList
        |> List.filterMap
            (\( key, cell ) ->
                if cell.entity == Player then
                    Just key

                else
                    Nothing
            )
        |> List.head


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

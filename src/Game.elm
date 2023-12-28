module Game exposing (Cell, Game, addBomb, addFloor, addLife, attackPlayer, empty, face, findFirstInDirection, fromCells, get, getPlayerPosition, insert, move, placeItem, remove, removeBomb, removeFloor, removeLife, slide, update)

import Config
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Entity
    exposing
        ( EffectType(..)
        , Enemy(..)
        , Entity(..)
        , Item(..)
        )
import Math
import Position
import Set exposing (Set)


type alias Cell =
    { id : Int
    , entity : Entity
    }


type alias Game =
    { cells : Dict ( Int, Int ) Cell
    , items : Dict ( Int, Int ) Item
    , floor : Set ( Int, Int )
    , nextId : Int
    , bombs : Int
    , lifes : Int
    , playerDirection : Direction
    }


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
    , floor =
        Position.asGrid
            { columns = Config.mapSize
            , rows = Config.mapSize
            }
            |> Set.fromList
    , bombs = 0
    , lifes = 1
    , nextId = 0
    , playerDirection = Down
    }


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
    { game | floor = game.floor |> Set.insert pos }


removeFloor : ( Int, Int ) -> Game -> Game
removeFloor pos game =
    { game | floor = game.floor |> Set.remove pos }


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


slide : ( Int, Int ) -> Direction -> Game -> Game
slide position direction game =
    let
        newLocation : ( Int, Int )
        newLocation =
            direction
                |> Direction.toVector
                |> Position.addToVector position
    in
    case
        game
            |> move
                { from = position
                , to = newLocation
                }
    of
        Just a ->
            slide newLocation direction a

        Nothing ->
            game


attackPlayer : ( Int, Int ) -> Game -> Maybe Game
attackPlayer position game =
    let
        newGame =
            game |> removeLife
    in
    game.cells
        |> Dict.get position
        |> Maybe.andThen
            (\cell ->
                case cell.entity of
                    Player ->
                        { newGame
                            | cells =
                                if newGame.lifes > 0 then
                                    newGame.cells

                                else
                                    newGame.cells
                                        |> Dict.insert position { cell | entity = Particle Bone }
                        }
                            |> Just

                    _ ->
                        Nothing
            )


face :
    Direction
    -> Game
    -> Game
face direction game =
    { game | playerDirection = direction }


removeLife : Game -> Game
removeLife game =
    { game | lifes = game.lifes - 1 |> max 0 }


addLife : Game -> Game
addLife player =
    { player | lifes = player.lifes + 1 |> min Config.maxLifes }


removeBomb : Game -> Maybe Game
removeBomb playerData =
    if playerData.bombs > 0 then
        Just { playerData | bombs = playerData.bombs - 1 }

    else
        Nothing


addBomb : Game -> Game
addBomb playerData =
    { playerData
        | bombs =
            playerData.bombs
                + 1
                |> min Config.maxBombs
    }

module Game exposing (Cell, Game, addBomb, addLife, attackPlayer, face, findFirstInDirection, fromCells, getPlayerPosition, insert, move, remove, removeBomb, removeLife, slide, update)

import Config
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Entity
    exposing
        ( EffectType(..)
        , EnemyType(..)
        , Entity(..)
        )
import Math
import Position


type alias Cell =
    { id : Int, entity : Entity }


type alias Game =
    { cells : Dict ( Int, Int ) Cell
    , nextId : Int
    , bombs : Int
    , lifes : Int
    }


remove : ( Int, Int ) -> Game -> Game
remove pos game =
    { game | cells = game.cells |> Dict.remove pos }


insert : ( Int, Int ) -> Entity -> Game -> Game
insert pos entity game =
    { game
        | cells = game.cells |> Dict.insert pos { id = game.nextId, entity = entity }
        , nextId = game.nextId + 1
    }


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


getPlayerPosition : Game -> Maybe ( ( Int, Int ), Direction )
getPlayerPosition game =
    game.cells
        |> Dict.toList
        |> List.filter
            (\( _, cell ) ->
                case cell.entity of
                    Player _ ->
                        True

                    _ ->
                        False
            )
        |> List.head
        |> Maybe.andThen
            (\( key, cell ) ->
                case cell.entity of
                    Player dir ->
                        Just ( key, dir )

                    _ ->
                        Nothing
            )


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


fromCells : Dict ( Int, Int ) Entity -> Game
fromCells cells =
    { cells =
        cells
            |> Dict.toList
            |> List.indexedMap (\i ( pos, entity ) -> ( pos, { id = i, entity = entity } ))
            |> Dict.fromList
    , bombs = 0
    , lifes = 1
    , nextId = Dict.size cells
    }


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
                    Player _ ->
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
    ( Int, Int )
    -> Direction
    -> Game
    -> Game
face position direction game =
    game
        |> update position (\_ -> Player direction)


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

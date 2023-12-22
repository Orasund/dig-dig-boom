module Player exposing
    ( PlayerData
    , addBomb
    , addLife
    , face
    , init
    , pushCrate
    , removeBomb
    , removeLife
    )

import Cell
    exposing
        ( Cell(..)
        , EffectType(..)
        , EnemyType(..)
        , ItemType(..)
        , Wall(..)
        )
import Config
import Dict exposing (Dict)
import Direction exposing (Direction(..))
import Html.Attributes exposing (dir)
import Math
import Position


type alias PlayerData =
    { bombs : Int
    , lifes : Int
    }


init : PlayerData
init =
    { bombs = 0
    , lifes = 1
    }


removeLife : PlayerData -> PlayerData
removeLife player =
    { player | lifes = player.lifes - 1 |> max 0 }


addLife : PlayerData -> PlayerData
addLife player =
    { player | lifes = player.lifes + 1 |> min Config.maxLifes }


face :
    ( Int, Int )
    -> Direction
    -> Dict ( Int, Int ) Cell
    -> Dict ( Int, Int ) Cell
face position direction map =
    map
        |> Dict.insert position (PlayerCell direction)


pushCrate : ( Int, Int ) -> Direction -> Dict ( Int, Int ) Cell -> Maybe (Dict ( Int, Int ) Cell)
pushCrate pos dir cells =
    let
        newPos =
            dir
                |> Direction.toCoord
                |> Position.addTo pos
    in
    Dict.get pos cells
        |> Maybe.andThen
            (\from ->
                if
                    Dict.get newPos
                        cells
                        == Nothing
                        && Math.posIsValid newPos
                then
                    cells
                        |> Dict.insert newPos from
                        |> Dict.remove pos
                        |> Just

                else
                    Nothing
            )


removeBomb : PlayerData -> Maybe PlayerData
removeBomb playerData =
    if playerData.bombs > 0 then
        Just { playerData | bombs = playerData.bombs - 1 }

    else
        Nothing


addBomb : PlayerData -> PlayerData
addBomb playerData =
    { playerData
        | bombs =
            playerData.bombs
                + 1
                |> min Config.maxBombs
    }

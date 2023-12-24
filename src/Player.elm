module Player exposing
    ( PlayerData
    , addBomb
    , addLife
    , init
    , removeBomb
    , removeLife
    )

import Config
import Direction exposing (Direction(..))
import Entity
    exposing
        ( EffectType(..)
        , EnemyType(..)
        , Entity(..)
        )


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

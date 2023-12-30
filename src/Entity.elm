module Entity exposing
    ( EffectType(..)
    , Enemy(..)
    , Entity(..)
    , Item(..)
    )

import Direction exposing (Direction)


type Enemy
    = PlacedBomb
    | Goblin Direction
    | Rat
    | Golem


type EffectType
    = Smoke
    | Bone


type Item
    = Heart
    | InactiveBomb


type Entity
    = Door
    | Player
    | Crate
    | Enemy Enemy
    | Stunned Enemy
    | Particle EffectType

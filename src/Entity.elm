module Entity exposing
    ( EffectType(..)
    , Enemy(..)
    , Entity(..)
    )

import Direction exposing (Direction)


type Enemy
    = PlacedBomb
    | Goblin Direction
    | Rat


type EffectType
    = Smoke
    | Bone


type Entity
    = Player
    | Crate
    | Enemy Enemy
    | Stunned Enemy
    | InactiveBomb
    | Heart
    | Particle EffectType

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


type EffectType
    = Smoke
    | Bone


type Item
    = Heart
    | InactiveBomb


type Entity
    = Player
    | Crate
    | Enemy Enemy
    | Stunned Enemy
    | Particle EffectType

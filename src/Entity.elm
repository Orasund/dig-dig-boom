module Entity exposing
    ( Enemy(..)
    , Entity(..)
    , Item(..)
    , ParticleSort(..)
    )

import Direction exposing (Direction)


type Enemy
    = PlacedBomb
    | Goblin Direction
    | Rat
    | Golem


type ParticleSort
    = Smoke
    | Bone


type Item
    = Bomb


type Entity
    = Door
    | Player
    | Crate
    | Enemy Enemy
    | Stunned Enemy

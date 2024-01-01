module Entity exposing
    ( Enemy(..)
    , Entity(..)
    , Item(..)
    , ParticleSort(..)
    )

import Direction exposing (Direction)


type Enemy
    = PlacedBomb Item
    | Goblin Direction
    | Rat
    | Golem


type ParticleSort
    = Smoke
    | Bone


type Item
    = Bomb
    | CrossBomb


type Entity
    = Door
    | Player
    | Crate
    | Enemy Enemy
    | Stunned Enemy

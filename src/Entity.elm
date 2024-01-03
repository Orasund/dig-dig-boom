module Entity exposing
    ( Enemy(..)
    , Entity(..)
    , Floor(..)
    , Item(..)
    , ParticleSort(..)
    )

import Direction exposing (Direction)


type Floor
    = Ground
    | CrateInLava


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
    | Sign String
    | Enemy Enemy
    | Stunned Enemy

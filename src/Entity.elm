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
    = ActivatedBomb Item
    | Orc Direction
    | Goblin
    | Doppelganger
    | Rat


type ParticleSort
    = Smoke
    | Bone


type Item
    = Bomb
    | CrossBomb


type Entity
    = Door { room : Int }
    | Player
    | Crate
    | InactiveBomb Item
    | ActiveSmallBomb
    | Sign String
    | Enemy Enemy
    | Stunned Enemy
    | Wall

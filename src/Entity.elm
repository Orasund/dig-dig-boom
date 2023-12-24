module Entity exposing
    ( EffectType(..)
    , EnemyType(..)
    , Entity(..)
    )

import Direction exposing (Direction(..))


type EnemyType
    = PlacedBomb
    | Oger
    | Goblin
    | Rat


type EffectType
    = Smoke
    | Bone


type Entity
    = Player Direction
    | Crate
    | Enemy EnemyType String
    | Stunned EnemyType String
    | InactiveBomb
    | Heart
    | Particle EffectType

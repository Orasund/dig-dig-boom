module Cell exposing
    ( Cell(..)
    , EffectType(..)
    , EnemyType(..)
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


type Cell
    = PlayerCell Direction
    | CrateCell
    | EnemyCell EnemyType String
    | StunnedCell EnemyType String
    | InactiveBombCell
    | HeartCell
    | EffectCell EffectType

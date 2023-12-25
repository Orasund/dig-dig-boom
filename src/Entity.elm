module Entity exposing
    ( EffectType(..)
    , EnemyType(..)
    , Entity(..)
    )


type EnemyType
    = PlacedBomb
    | Oger
    | Goblin
    | Rat


type EffectType
    = Smoke
    | Bone


type Entity
    = Player
    | Crate
    | Enemy EnemyType
    | Stunned EnemyType
    | InactiveBomb
    | Heart
    | Particle EffectType

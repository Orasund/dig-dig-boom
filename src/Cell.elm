module Cell exposing
    ( Cell(..)
    , EffectType(..)
    , EnemyType(..)
    , Wall(..)
    , decomposing
    , getImage
    )

import Direction exposing (Direction(..))
import PixelEngine.Tile exposing (Tile)
import View.Tile as Tile


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
    | WallCell Wall
    | EnemyCell EnemyType String
    | StunnedCell EnemyType String
    | InactiveBombCell
    | HeartCell
    | EffectCell EffectType


type Wall
    = StoneWall
    | StoneBrickWall
    | DirtWall


decomposing : Wall -> Maybe Wall
decomposing solidType =
    case solidType of
        DirtWall ->
            Nothing

        StoneWall ->
            Just DirtWall

        StoneBrickWall ->
            Just StoneWall


getImage : Cell -> Tile msg
getImage cell =
    case cell of
        PlayerCell a ->
            (case a of
                Down ->
                    Tile.player_down

                Up ->
                    Tile.player_up

                Left ->
                    Tile.player_left

                Right ->
                    Tile.player_right
            )
                Tile.colorWhite

        CrateCell ->
            Tile.crate Tile.colorBrown

        WallCell DirtWall ->
            Tile.dirt_wall Tile.colorBrown

        WallCell StoneWall ->
            Tile.stone_wall Tile.colorGray

        WallCell StoneBrickWall ->
            Tile.stone_brick_wall Tile.colorGray

        InactiveBombCell ->
            Tile.bombe Tile.colorGreen

        HeartCell ->
            Tile.health_potion Tile.colorGreen

        EnemyCell enemy id ->
            (case enemy of
                PlacedBomb ->
                    Tile.placed_bombe id

                Oger ->
                    Tile.oger id

                Goblin ->
                    Tile.goblin id

                Rat ->
                    Tile.rat id
            )
                Tile.colorRed

        StunnedCell enemy id ->
            (case enemy of
                PlacedBomb ->
                    Tile.placed_bombe id

                Oger ->
                    Tile.oger id

                Goblin ->
                    Tile.goblin id

                Rat ->
                    Tile.rat id
            )
                Tile.colorYellow

        EffectCell effect ->
            (case effect of
                Smoke ->
                    Tile.smoke

                Bone ->
                    Tile.bone
            )
                Tile.colorWhite

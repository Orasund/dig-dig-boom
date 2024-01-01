module Math exposing (..)

import Config


posIsValid : ( Int, Int ) -> Bool
posIsValid ( x, y ) =
    (0 <= x && x < Config.roomSize)
        && (0 <= y && y < Config.roomSize)

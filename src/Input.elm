module Input exposing (..)

import Direction exposing (Direction)


type Input
    = InputDir Direction
    | InputActivate
    | InputUndo
    | InputReset
    | InputOpenMap

module Gen.Sound exposing (Sound(..), toString, fromString, asList)

{-| This module was generated. Any changes will be overwritten.

@docs Sound, toString, fromString, asList

-}
    
{-| Reprentation of Sound
-}
type Sound = Explosion | Move | Push | Retry | Undo | Win

{-| List of all playable sounds
-}
asList : List Sound
asList =
    [ Explosion, Move, Push, Retry, Undo, Win ]

{-| returns the path to the sound
-}
toString : Sound -> String
toString sound =
    case sound of
      Explosion -> "explosion.wav"

      Move -> "move.wav"

      Push -> "push.wav"

      Retry -> "retry.wav"

      Undo -> "undo.wav"

      Win -> "win.wav"

fromString : String -> Maybe Sound
fromString string =
    case string of
      "explosion.wav" -> Just Explosion

      "move.wav" -> Just Move

      "push.wav" -> Just Push

      "retry.wav" -> Just Retry

      "undo.wav" -> Just Undo

      "win.wav" -> Just Win
      _ -> Nothing   

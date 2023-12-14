# Migrate an existing codebase

Migrating from an existing codebase is quite easy:

1. copy replace the `src` folder with your own
2. in the `init` function, add `Gen.Sound.asList |> RegisterSounds |> Port.fromElm`

Done! You're ready to go.
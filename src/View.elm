module View exposing (..)

import Config
import Html exposing (Html)
import Html.Viewport


viewportMeta : Html msg
viewportMeta =
    Html.Viewport.fixedWidth []
        --device-width
        Config.screenMinWidth


stylesheet : Html msg
stylesheet =
    --In-Elm Stylesheet is usually easier to load by itch.io
    "" |> Html.text |> List.singleton |> Html.node "style" []

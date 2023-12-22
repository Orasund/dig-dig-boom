module View.Screen exposing (death, menu, world)

import Cell exposing (Cell(..), EnemyType(..), ItemType(..), Wall(..))
import Color
import Config
import Dict
import Html exposing (Html)
import Html.Attributes
import Image
import Layout
import PixelEngine exposing (Input)
import PixelEngine.Image
import PixelEngine.Options as Options
import PixelEngine.Tile as Tile exposing (Tile, Tileset)
import Player exposing (Game)
import View.Controls
import View.Item
import View.Tile as TileView


logo : Int -> Html msg
logo frame =
    Image.sprite [ Image.pixelated ]
        { url = "title_image.png"
        , width = 350
        , height = 350
        , sheetColumns = 2
        , sheetRows = 1
        , pos = ( frame, 0 )
        }


death : Html msg
death =
    let
        width : Int
        width =
            16
    in
    [ PixelEngine.tiledArea
        { rows = 2
        , background = PixelEngine.colorBackground (Color.rgb255 20 12 28)
        , tileset = TileView.tileset
        }
        []
    , PixelEngine.tiledArea
        { rows = 2
        , background = PixelEngine.colorBackground (Color.rgb255 20 12 28)
        , tileset = TileView.tileset
        }
        (List.concat
            [ ( 4, 0 ) |> TileView.text "You have" TileView.colorWhite
            , ( 6, 1 ) |> TileView.text "died" TileView.colorWhite
            ]
        )
    , PixelEngine.imageArea
        { height = toFloat <| 12 * 16
        , background = PixelEngine.colorBackground (Color.rgb255 20 12 28)
        }
        [ ( ( toFloat <| (16 * width) // 2 - 64, toFloat <| (12 * width) // 2 - 64 )
          , PixelEngine.Image.fromSrc "skull.png"
          )
        ]
    , PixelEngine.tiledArea
        { rows = 2
        , background = PixelEngine.colorBackground (Color.rgb255 20 12 28)
        , tileset = TileView.tileset
        }
        (List.concat
            [ ( 4, 0 ) |> TileView.text "Press any" TileView.colorWhite
            , ( 6, 1 ) |> TileView.text "button" TileView.colorWhite
            ]
        )
    , PixelEngine.tiledArea
        { rows = 2
        , background = PixelEngine.colorBackground (Color.rgb255 20 12 28)
        , tileset = TileView.tileset
        }
        []
    ]
        |> PixelEngine.toHtml
            { width = toFloat <| TileView.tileset.spriteWidth * width
            , options =
                Options.default
                    |> Options.withScale 2
                    |> Just
            }


menu : { frame : Int } -> Html msg
menu args =
    [ [ "DIG" |> Layout.text [ Layout.contentCentered ]
      , "DIG" |> Layout.text [ Layout.contentCentered ]
      , "BOOM" |> Layout.text [ Layout.contentCentered ]
      ]
        |> Layout.column
            [ Html.Attributes.style "font-size" "60px"
            , Html.Attributes.style "color" "white"
            ]
    , logo args.frame
    ]
        |> Layout.column []


world : { score : Int, onInput : Input -> msg } -> Game -> List ( ( Int, Int ), Tile msg ) -> Html msg
world args game hints =
    [ [ "Score:"
            ++ String.fromInt args.score
            |> Layout.text [ Html.Attributes.style "font-size" "32px" ]
      ]
        |> Layout.row
            [ Layout.contentWithSpaceBetween
            , Html.Attributes.style "color" "white"
            ]
    , PixelEngine.tiledArea
        { rows = Config.mapSize
        , background =
            PixelEngine.imageBackground
                { source = "groundTile.png", width = 32, height = 32 }
        , tileset = TileView.tileset
        }
        (hints
            |> List.append
                (game.cells
                    |> Dict.toList
                    |> List.map
                        (\( pos, cell ) -> ( pos, Cell.getImage cell ))
                )
        )
        |> List.singleton
        |> PixelEngine.toHtml
            { width = toFloat <| TileView.tileset.spriteWidth * Config.mapSize
            , options =
                Options.default
                    |> Options.withScale 4
                    |> Just
            }
    , [ View.Item.toHtml Bomb
            |> List.repeat game.player.bombs
            |> Layout.row []
      , Image.image [ Image.pixelated ]
            { url = "heart.png"
            , width = 64
            , height = 64
            }
            |> List.repeat (game.player.lifes - 1)
            |> Layout.row []
      ]
        |> Layout.row [ Layout.contentWithSpaceBetween ]
    , View.Controls.toHtml
        { onInput = args.onInput }
    ]
        |> Layout.column
            (Html.Attributes.style "width" "400px"
                :: Layout.centered
            )

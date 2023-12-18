module View.Screen exposing (death, menu, world)

import Cell exposing (Cell(..), EnemyType(..), ItemType(..), SolidType(..))
import Color
import Config
import Dict
import Html exposing (Html)
import Html.Attributes
import Image
import Layout
import PixelEngine
import PixelEngine.Image
import PixelEngine.Options as Options
import PixelEngine.Tile as Tile exposing (Tile, Tileset)
import Player exposing (Game)
import View.Item
import View.Tile as TileView


logo : Tileset
logo =
    Tile.tileset { source = "title_image.png", spriteHeight = 128, spriteWidth = 128 }


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


menu : Html msg
menu =
    let
        width : Int
        width =
            16

        tile : Tile msg
        tile =
            Tile.fromPosition ( 0, 0 ) |> Tile.animated 2
    in
    [ PixelEngine.tiledArea
        { rows = 2
        , background = PixelEngine.colorBackground (Color.rgb255 20 12 28)
        , tileset = TileView.tileset
        }
        []
    , PixelEngine.tiledArea
        { rows = 3
        , background = PixelEngine.colorBackground (Color.rgb255 20 12 28)
        , tileset = TileView.tileset
        }
        (List.concat
            [ ( 5, 0 ) |> TileView.text "DIG" TileView.colorWhite
            , ( 6, 1 ) |> TileView.text "DIG" TileView.colorWhite
            , ( 6, 2 ) |> TileView.text "BOOM" TileView.colorWhite
            ]
        )
    , PixelEngine.imageArea
        { height = toFloat <| 9 * 16
        , background = PixelEngine.colorBackground (Color.rgb255 20 12 28)
        }
        [ ( ( toFloat <| (16 * width) // 2 - 64, 0 ), PixelEngine.Image.fromTile tile logo )
        ]
    , PixelEngine.tiledArea
        { rows = 4
        , background = PixelEngine.colorBackground (Color.rgb255 20 12 28)
        , tileset = TileView.tileset
        }
        (List.concat
            [ ( 1, 0 ) |> TileView.text "a" TileView.colorWhite
            , [ ( ( 2, 0 ), TileView.arrow_left TileView.colorWhite )
              , ( ( 3, 0 ), TileView.arrow_right TileView.colorWhite )
              ]
            , ( 4, 0 ) |> TileView.text "d -Start" TileView.colorWhite
            , ( 8, 1 ) |> TileView.text "Game" TileView.colorWhite
            , ( 1, 3 ) |> TileView.text "w" TileView.colorWhite
            , [ ( ( 2, 3 ), TileView.arrow_up TileView.colorWhite )
              , ( ( 3, 3 ), TileView.arrow_down TileView.colorWhite )
              ]
            , ( 4, 3 ) |> TileView.text "s -Tutorial" TileView.colorWhite
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


world : Int -> Game -> List ( ( Int, Int ), Tile msg ) -> Html msg
world worldSeed game hints =
    [ [ "Score:"
            ++ (if (worldSeed // abs worldSeed) == -1 then
                    "-"

                else
                    " "
               )
            ++ String.fromInt (modBy 100 (abs worldSeed) // 10)
            ++ String.fromInt (modBy 10 (abs worldSeed))
            |> Layout.text [ Html.Attributes.style "font-size" "32px" ]
      , Image.image [ Image.pixelated ]
            { url = "heart.png"
            , width = 32
            , height = 32
            }
            |> List.repeat game.player.lifes
            |> Layout.row []
      ]
        |> Layout.row [ Layout.contentWithSpaceBetween ]
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
    , View.Item.toHtml Bombe
        |> List.repeat game.player.bombs
        |> Layout.row []
    ]
        |> Layout.column []

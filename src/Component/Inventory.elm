module Component.Inventory exposing
    ( Inventory
    , add
    , drop
    , get
    , init
    , rotateLeft
    , rotateRight
    , selected
    )


type alias Inventory a =
    { maxLength : Int
    , items : List a
    }


init : Int -> Inventory a
init max_length =
    { maxLength = max_length
    , items = []
    }


add : a -> Inventory a -> Maybe (Inventory a)
add item inventory =
    if inventory.maxLength > List.length inventory.items then
        { inventory | items = item :: inventory.items }
            |> Just

    else
        Nothing


rotateLeft : Inventory a -> Inventory a
rotateLeft inventory =
    { inventory
        | items =
            (inventory.items |> List.drop (List.length inventory.items - 1))
                ++ (inventory.items |> List.take (List.length inventory.items - 1))
    }


rotateRight : Inventory a -> Inventory a
rotateRight inventory =
    { inventory
        | items =
            (inventory.items |> List.drop 1)
                ++ (inventory.items |> List.take 1)
    }


drop : Inventory a -> ( Maybe a, Inventory a )
drop inventory =
    ( inventory.items |> List.head
    , { inventory
        | items =
            inventory.items
                |> List.tail
                |> Maybe.withDefault []
      }
    )


get : Inventory a -> List a
get inventory =
    inventory.items


selected : Inventory a -> Maybe a
selected inventory =
    inventory.items |> List.head

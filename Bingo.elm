module Bingo exposing (..)

import Html


-- main =
-- Html.text (String.repeat 3 (String.toUpper "rolands game #3"))


main =
    "rolands game #3 "
        |> String.toUpper
        |> String.repeat 3
        |> String.pad 100 '*'
        |> Html.text

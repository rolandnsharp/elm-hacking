module Bingo exposing (..)

import Html


playerInfo name gameNumber =
    name ++ " - Game #" ++ gameNumber


playerInfoText name gameNumber =
    playerInfo name gameNumber
        |> String.toUpper
        |> Html.text


main =
    playerInfoText "Roland " "3"

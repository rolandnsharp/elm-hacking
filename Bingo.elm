module Bingo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


type alias Model =
    { name : String
    , gameNumber : Int
    , entries : List Entry
    }


type alias Entry =
    { id : Int
    , phrase : String
    , points : Int
    , marked : Bool
    }


initialModel : Model
initialModel =
    { name = "Jesus"
    , gameNumber = 1
    , entries = initialEntries
    }


initialEntries : List Entry
initialEntries =
    [ Entry 1 "Future-proof" 100 False
    , Entry 2 "blah" 200 False
    , Entry 3 "fdgfdgfd" 500 True
    , Entry 4 "nonononoyes" 250 False
    ]



-- VIEW


playerInfo : String -> Int -> String
playerInfo name gameNumber =
    name ++ " - Game #" ++ toString gameNumber


viewPlayer : String -> Int -> Html msg
viewPlayer name gameNumber =
    let
        playerInfoText =
            playerInfo name gameNumber
                |> String.toUpper
                |> text
    in
    h2 [ id "info", class "classy" ]
        [ playerInfoText ]


viewHeader : String -> Html msg
viewHeader title =
    header []
        [ h1 [] [ text title ] ]


viewFooter : Html msg
viewFooter =
    footer []
        [ a [ href "http://elm-lang.org" ]
            [ text "Powered by elm" ]
        ]


view : Model -> Html msg
view model =
    div [ class "content" ]
        [ viewHeader "Buzword bingo"
        , viewPlayer model.name model.gameNumber
        , div [ class "debug" ] [ text (toString model) ]
        , viewFooter
        ]


main : Html msg
main =
    view initialModel

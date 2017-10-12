module Bingo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


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
    , Entry 3 "xox" 500 True
    , Entry 4 "nonononoyes" 250 False
    ]



-- UPDATE


type Msg
    = NewGame
    | Mark Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewGame ->
            { model
                | gameNumber = model.gameNumber + 1
                , entries = initialEntries
            }

        Mark id ->
            let
                markEntry e =
                    if e.id == id then
                        { e | marked = not e.marked }
                    else
                        e
            in
            { model | entries = List.map markEntry model.entries }



-- returns new model
--- { record to update | name of field = current game number + 1}
-- VIEW


playerInfo : String -> Int -> String
playerInfo name gameNumber =
    name ++ " - Game #" ++ toString gameNumber


viewPlayer : String -> Int -> Html Msg
viewPlayer name gameNumber =
    let
        playerInfoText =
            playerInfo name gameNumber
                |> String.toUpper
                |> text
    in
    h2 [ id "info", class "classy" ]
        [ playerInfoText ]


viewHeader : String -> Html Msg
viewHeader title =
    header []
        [ h1 [] [ text title ] ]


viewFooter : Html Msg
viewFooter =
    footer []
        [ a [ href "http://elm-lang.org" ]
            [ text "Powered by elm" ]
        ]


viewEntryItem : Entry -> Html Msg
viewEntryItem entry =
    li [ classList [ ( "marked", entry.marked ) ], onClick (Mark entry.id) ]
        -- wtf^^ tupla -- display "marked" when entry is marked as true
        [ span [ class "phrase" ] [ text entry.phrase ]
        , span [ class "points" ] [ text (toString entry.points) ]
        ]


viewEntryList : List Entry -> Html Msg
viewEntryList entries =
    entries
        |> List.map viewEntryItem
        |> ul []



-- let
--     listOfEntries =
--         List.map viewEntryItem entries
-- in
-- ul [] listOfEntries


sumMarkedPoints : List Entry -> Int
sumMarkedPoints entries =
    entries
        |> List.filter .marked
        |> List.map .points
        |> List.sum



-- let
--     markedEntries =
--         -- List.filter (\e -> e.marked) entries -- refactor
--         List.filter .marked entries
--     pointValues =
--         List.map .points markedEntries
-- in
-- List.sum pointValues


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ viewHeader "Buzword bingo"
        , viewPlayer model.name model.gameNumber
        , viewEntryList model.entries
        , div [ class "button-group" ] [ button [ onClick NewGame ] [ text "new game" ] ]
        , div [ class "debug" ] [ text (toString model) ]
        , viewFooter
        ]



-- main : Html Msg
-- main =
--     update NewGame initialModel
--         |> view


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }

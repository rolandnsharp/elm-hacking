module Bingo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Random


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
    , entries = []

    -- , entries = initialEntries
    }



-- initialEntries : List Entry
-- initialEntries =
--     [ Entry 1 "Future-proof" 100 False
--     , Entry 2 "blah" 200 False
--     , Entry 3 "xox" 500 False
--     , Entry 4 "nonononoyes" 250 False
--     ]
-- UPDATE


type Msg
    = NewGame
    | Mark Int
    | NewRandom Int
    | NewEntries (Result Http.Error (List Entry))



-- return a tupal with the model and the collection of commands that we want the eml runtime to execute
-- All commands must be idempotent/pure function therefor randomNumber must be sent via a command to the elm runtime.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewRandom randomNumber ->
            ( { model | gameNumber = randomNumber }, Cmd.none )

        NewGame ->
            -- ( { model | gameNumber = model.gameNumber + 1, entries = initialEntries }, Cmd.none )
            -- we want to create a random game nuber with a new game and it will have to be done in a command for the elm runtime to keep the function deterministic
            -- ( { model | entries = initialEntries }, generateRandomNumber )
            ( { model | gameNumber = model.gameNumber + 1 }, getEntries )

        NewEntries (Ok randomEntries) ->
            ( { model | entries = randomEntries }, Cmd.none )

        NewEntries (Err error) ->
            let
                _ =
                    Debug.log "errorzzzzzzzzz" error
            in
            ( model, Cmd.none )

        Mark id ->
            let
                markEntry e =
                    if e.id == id then
                        { e | marked = not e.marked }
                    else
                        e
            in
            ( { model | entries = List.map markEntry model.entries }, Cmd.none )



--DECODERS


entryDecoder : Decoder Entry
entryDecoder =
    Decode.map4 Entry
        (field "id" Decode.int)
        (field "phrase" Decode.string)
        (field "points" Decode.int)
        (succeed False)



-- returns new model
--- { record to update | name of field = current game number + 1}
-- COMMANDS


generateRandomNumber : Cmd Msg
generateRandomNumber =
    -- Random.generate (\num -> NewRandom num) (Random.int 1 100)
    Random.generate NewRandom (Random.int 1 100)


entriesUrl : String
entriesUrl =
    "http://localhost:3000/random-entries"


getEntries : Cmd Msg
getEntries =
    -- NewEntries message gives us a constructor function to provide result to message
    -- Http.send NewEntries (Http.getString entriesUrl)
    -- entriesUrl
    --     |> Http.getString
    --     |> Http.send NewEntries
    -- Http.send (\result -> NewEntries result ) (Http.getString entriesUrl)
    -- send : (Result Http.Error String -> Msg) -> Request String -> Cmd Msg
    -- SOMETHING
    -- Using decoding
    Decode.list entryDecoder
        |> Http.get entriesUrl
        |> Http.send NewEntries


playerInfo : String -> Int -> String
playerInfo name gameNumber =
    name ++ " - Game #" ++ toString gameNumber



-- VIEW


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



-- sumMarkedPoints : List Entry -> Int
-- sumMarkedPoints entries =
-- let
--     markedEntries =
--         -- List.filter (\e -> e.marked) entries -- refactor
--         List.filter .marked entries
--     pointValues =
--         List.map .points markedEntries
-- in
-- List.sum pointValues


viewScore : Int -> Html Msg
viewScore sum =
    div
        [ class "score" ]
        [ span [ class "label" ] [ text "Score" ]
        , span [ class "value" ] [ text (toString sum) ]
        ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ viewHeader "Buzword bingo"
        , viewPlayer model.name model.gameNumber
        , viewEntryList model.entries
        , viewScore (sumMarkedPoints model.entries)
        , div [ class "button-group" ] [ button [ onClick NewGame ] [ text "new game" ] ]
        , div [ class "debug" ] [ text (toString model) ]
        , viewFooter
        ]



-- main : Html Msg
-- main =
--     update NewGame initialModel
--         |> view
-- main =
-- ####
-- Html.beginnerProgram
--     { model = initialModel
--     , view = view
--     , update = update
--     }


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, getEntries )
        , view = view
        , update = update

        -- , subscriptions = \model -> Sub.none
        , subscriptions = \_ -> Sub.none
        }



-- elm-live Bingo.elm --open --debug --output=bingo.js

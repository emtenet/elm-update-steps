module CounterList exposing
  ( Model
  , init
  , Msg
  , update
  , view
  ) -- where


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Counter
import Update


-- MODEL

type alias Model =
  { counters : List ( ID, Counter.Model )
  , nextID : ID
  }

type alias ID = Int


init : Model
init =
  { counters = []
  , nextID = 0
  }


-- UPDATE


type Msg
  = Insert
  | Remove
  | Counter ID Counter.Msg


update : Msg -> Model -> Update.Step Msg Model
update msg model =
  case msg of
    Insert ->
      let
        newCounter = ( model.nextID, Counter.init 0 )
        newCounters = model.counters ++ [ newCounter ]
      in
        Update.Model
          { model
          | counters = newCounters
          , nextID = model.nextID + 1
          }

    Remove ->
      Update.Model { model | counters = List.drop 1 model.counters }

    Counter id msg' ->
      Update.list id msg' model.counters (Counter id, \x -> { model | counters = x }) Counter.update


-- VIEW

view : (Msg -> msg) -> Model -> Html msg
view tag model =
  let
    counters = List.map (viewCounter tag) model.counters
    remove = button [ onClick (tag Remove) ] [ text "Remove" ]
    insert = button [ onClick (tag Insert) ] [ text "Add" ]
  in
    div [] ([remove, insert] ++ counters)


viewCounter : (Msg -> msg) -> (ID, Counter.Model) -> Html msg
viewCounter tag (id, model) =
  Counter.view (tag << Counter id) model

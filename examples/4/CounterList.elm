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
  | Remove ID
  | Counter ID Counter.Msg


update : Msg -> Model -> Update.Step Msg Model
update msg model =
  case msg of
    Insert ->
      Update.Model
        { model
        | counters = model.counters ++ [ ( model.nextID, Counter.init 0 ) ]
        , nextID = model.nextID + 1
        }

    Remove id ->
      Update.Model { model | counters = List.filter (\(x, _) -> x /= id) model.counters }

    Counter id msg' ->
      Update.list id msg' model.counters (Counter id, \x -> { model | counters = x }) Counter.update


-- VIEW

view : (Msg -> msg) -> Model -> Html msg
view tag model =
  let
    counters = List.map (viewCounter tag) model.counters
    insert = button [ onClick (tag Insert) ] [ text "Add" ]
  in
    div [] (insert :: counters)


viewCounter : (Msg -> msg) -> (ID, Counter.Model) -> Html msg
viewCounter tag (id, model) =
  let
    remove = button [ onClick (tag <| Remove id) ] [ text "Remove" ]
  in
    Counter.viewWithButtons (tag << Counter id) model [ remove ]

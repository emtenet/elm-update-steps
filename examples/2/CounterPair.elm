module CounterPair exposing
  ( Msg
  , Model
  , init
  , update
  , view
  ) -- where


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


import Update
import Counter


-- MODEL


type alias Model =
  { top : Counter.Model
  , bottom : Counter.Model
  }


init : Int -> Int -> Model
init top bottom =
  { top = Counter.init top
  , bottom = Counter.init bottom
  }


-- UPDATE


type Msg
  = Reset
  | Top Counter.Msg
  | Bottom Counter.Msg


update : Msg -> Model -> Update.Step Msg Model
update msg model =
  case msg of
    Reset ->
      Update.Model (init 0 0)

    Top msg' ->
      Update.component msg' model.top (Top, \x -> { model | top = x }) Counter.update

    Bottom msg' ->
      Update.component msg' model.bottom (Bottom, \x -> { model | bottom = x }) Counter.update


-- VIEW


view : (Msg -> msg) -> Model -> Html msg
view tag model =
  div []
    [ Counter.view (tag << Top) model.top
    , Counter.view (tag << Bottom) model.bottom
    , button [ onClick (tag Reset) ] [ text "RESET" ]
    ]

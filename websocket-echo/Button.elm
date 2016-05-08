module Button exposing ( Msg (Clicked), Model, init, update, view) -- where


import Html exposing (Html, button, text)
import Html.App
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)

import Update


-- MODEL


type Msg 
  = Click
  -- public messages
  | Clicked


type alias Model =
  { disabled : Bool }


init : Model
init = 
  { disabled = False }


enable : Model -> Model
enable model =
  { model | disabled = False }


disable : Model -> Model
disable model =
  { model | disabled = True }


-- UPDATE

update : Msg -> Model -> Update.Step Msg Model
update msg model =
  case msg of
    Click ->
      Update.Notify Clicked

    Clicked ->
      Update.NotifyIgnored


-- VIEW


view : (Msg -> msg) -> Model -> String -> Html msg
view tag model title =
  viewWithContent tag model [ text title ]


viewWithContent : (Msg -> msg) -> Model -> List (Html msg) -> Html msg
viewWithContent tag model content =
  let
    attributes =
      [ onClick (tag Click)
      , disabled model.disabled
      ]
  in
    button attributes content

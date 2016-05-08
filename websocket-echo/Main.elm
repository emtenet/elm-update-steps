import Html exposing (Html)
import Html.App
import Html.Attributes


import Messages
import Update


main =
  Html.App.program
    { init = init
    , view = view
    , update = Update.app update
    , subscriptions = subscriptions
    }


-- MODEL


type Msg
  = Messages Messages.Msg


type alias Model =
  { messages : Messages.Model }


init : (Model, Cmd Msg)
init =
  ( { messages = Messages.init }
  , Cmd.none
  )


-- UPDATE


update : Msg -> Model -> Update.Step Msg Model
update msg model =
  case msg of
    Messages msg' ->
      Update.component msg' model.messages (Messages, \x -> { model | messages = x }) Messages.update

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Messages.subscriptions (Messages) model.messages


-- VIEW


view : Model -> Html Msg
view model =
  Html.div [ style ] 
    [ Html.h1 [] [ Html.text "Elm echo sample" ]
    , Messages.view (Messages) model.messages
    ]


style : Html.Attribute Msg
style =
  Html.Attributes.style
    [ ("maxWidth", "300px")
    , ("margin", "0px auto")
    ]
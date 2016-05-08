module SendMessage exposing
  ( Msg (SendMessage)
  , Model
  , init
  , update
  , view
  ) -- where


import Html exposing (..)

import Button
import TextBox
import Update


-- MODEL


type Msg
  = Text TextBox.Msg
  | Send Button.Msg
  | SendClicked
  | SendMessage String


type alias Model =
  { text : TextBox.Model
  , send : Button.Model
  }


init : Model
init =
  { text = TextBox.init "message-text"
  , send = Button.init
  }


-- UPDATE

update : Msg -> Model -> Update.Step Msg Model
update msg model =
  case msg of
    Text TextBox.EnterPressed ->
      Update.Msg SendClicked

    Text msg' ->
      Update.component msg' model.text (Text, \x -> { model | text = x }) TextBox.update

    Send Button.Clicked ->
      Update.Msg SendClicked

    Send msg' ->
      Update.component msg' model.send (Send, \x -> { model | send = x }) Button.update

    SendClicked ->
      Update.ModelAndNotify
        { model | text = TextBox.textSetAsEmpty model.text }
        (SendMessage (TextBox.text model.text))

    SendMessage _ ->
      Update.NotifyIgnored


-- VIEW


view : (Msg -> msg) -> Model -> Html msg
view tag model =
  div []
    [ Html.p [] [ Html.text "Type a message then press Enter or click Send" ]
    , TextBox.view (tag << Text) model.text "Message to send"
    , Button.view (tag << Send) model.send "Send"
    ]

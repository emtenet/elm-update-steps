module Messages exposing
  ( Msg
  , Model
  , init
  , update
  , subscriptions
  , view
  ) -- where


import Html exposing (Html)
import Html.Attributes
import WebSocket


import SendMessage as Sender
import Message
import Update


-- MODEL


type Msg
  = Sender Sender.Msg
  | ReceiveMessage String
  | Message ID Message.Msg


type alias Model =
  { sender : Sender.Model
  , messages : List (ID, Message.Model)
  , nextID : ID
  }


type alias ID = Int


init : Model
init =
  { sender = Sender.init
  , messages = []
  , nextID = 0
  }


-- WEBSOCKET


echoServer : String
echoServer = "ws://echo.websocket.org"


-- UPDATE

update : Msg -> Model -> Update.Step Msg Model
update msg model =
  case msg of
    Sender (Sender.SendMessage message) ->
      Update.Cmd (WebSocket.send echoServer message)

    Sender msg' ->
      Update.component msg' model.sender (Sender, \x -> { model | sender = x }) Sender.update

    ReceiveMessage text ->
      let
        id = model.nextID
        message = Message.init text
      in
        Update.Model 
          { model 
          | messages = (id, message) :: model.messages
          , nextID = model.nextID + 1
          }

    Message id msg' ->
      Update.list id msg' model.messages (Message id, \x -> { model | messages = x }) Message.update


-- SUBSCRIPTIONS


subscriptions : (Msg -> msg) -> Model -> Sub msg
subscriptions tag model =
  WebSocket.listen echoServer (tag << ReceiveMessage)


-- VIEW


view : (Msg -> msg) -> Model -> Html msg
view tag model =
  Html.div []
    [ Sender.view (tag << Sender) model.sender
    , Html.div [] (List.map (viewMessage tag) (List.reverse model.messages))
    ]


viewMessage : (Msg -> msg) -> (ID, Message.Model) -> Html msg
viewMessage tag (id, message) =
  Message.view (tag << Message id) message
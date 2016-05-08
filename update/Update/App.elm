module Update.App exposing ( program ) -- where


import Html exposing (Html)
import Html.App


import Update


program 
  : { init : model
    , update : msg -> model -> Update.Step msg model
    , view : (msg -> msg) -> model -> Html msg
    }
  -> Program Never
program with =
  Html.App.program
    { init = init with.init
    , view = view with.view
    , update = Update.app (update with.update)
    , subscriptions = subscriptions
    }


-- MODEL


init : model -> (model, Cmd msg)
init model =
  ( model
  , Cmd.none
  )


-- UPDATE


update
  : (msg -> model -> Update.Step msg model)
  -> msg 
  -> model
  -> Update.Step msg model
update with msg model =
  Update.component msg model (\m -> m, \x -> x) with


-- SUBSCRIPTIONS


subscriptions : model -> Sub msg
subscriptions model =
  Sub.none


-- VIEW


view
  : ((msg -> msg) -> model -> Html msg)
  -> model
  -> Html msg
view with model =
  with (\m -> m) model

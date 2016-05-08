module Update exposing
  ( Step (..)
  , app
  , component
  , list
  ) -- where


type Step msg model
  = Ignore
  | Cmd (Cmd.Cmd msg)
  | Msg msg
  | Notify msg
  | NotifyIgnored
  | Model model
  | ModelAndCmd model (Cmd.Cmd msg)
  | ModelAndMsg model msg
  | ModelAndNotify model msg


-- APP


app
  : (msg -> model -> Step msg model) 
  -> msg
  -> model
  -> (model, Cmd msg)
app step msg model =
  appFold msg model step


appFold
  : msg 
  -> model 
  -> (msg -> model -> Step msg model) 
  -> (model, Cmd msg)
appFold msg model step =
  case step msg model of
    Ignore ->
      (model, Cmd.none)

    Cmd cmd ->
      (model, cmd)

    Msg msg' ->
      appFold msg' model step

    Notify msg' ->
      -- no one to notify, ignore instead
      (model, Cmd.none)

    NotifyIgnored ->
      (model, Cmd.none)

    Model model' ->
      (model', Cmd.none)

    ModelAndCmd model' cmd ->
      (model', cmd)

    ModelAndMsg model' msg' ->
      appFold msg' model' step

    ModelAndNotify model' msg' ->
      -- no one to notify, ignore instead
      (model', Cmd.none)


-- COMPONENT


component
  : msg 
  -> model 
  -> (msg -> msg', model -> model') 
  -> (msg -> model -> Step msg model) 
  -> Step msg' model'
component msg model (tag, wrap) step =
  componentFold msg model False tag wrap step


componentFold
  : msg 
  -> model 
  -> Bool
  -> (msg -> msg')
  -> (model -> model') 
  -> (msg -> model -> Step msg model) 
  -> Step msg' model'
componentFold msg model updated tag wrap step =
  case step msg model of
    Ignore ->
      case updated of
        True ->
          Model (wrap model)
        False ->
          Ignore

    Cmd cmd ->
      case updated of
        True ->
          ModelAndCmd (wrap model) (Cmd.map tag cmd)
        False ->
          Cmd (Cmd.map tag cmd)

    Msg msg' ->
      componentFold msg' model updated tag wrap step

    Notify msg' ->
      case updated of
        True ->
          ModelAndMsg (wrap model) (tag msg')
        False ->
          Msg (tag msg')

    NotifyIgnored ->
      case updated of
        True ->
          Model (wrap model)
        False ->
          Ignore

    Model model' ->
      Model (wrap model')

    ModelAndCmd model' cmd ->
      ModelAndCmd (wrap model') (Cmd.map tag cmd)

    ModelAndMsg model' msg' ->
      componentFold msg' model' True tag wrap step

    ModelAndNotify model' msg' ->
      ModelAndMsg (wrap model') (tag msg')


-- LIST


list
  : id
  -> msg 
  -> List (id, model)
  -> (msg -> msg', List (id, model) -> model') 
  -> (msg -> model -> Step msg model) 
  -> Step msg' model'
list id msg models (tag, wrap) step =
  case listFindById id models of
    Nothing ->
      Ignore

    Just model ->
      let
        wrap' = wrap << listReplaceById id models
      in
        componentFold msg model False tag wrap' step


listFindById : id -> List (id, model) -> Maybe model
listFindById id models =
  let
    find (id', _) = (id' == id)
  in
    case List.filter find models of
      [ (_, model) ] ->
        Just model
      _ ->
        Nothing


listReplaceById : id -> List (id, model) -> model -> List (id, model)
listReplaceById id models with =
  let
    replace model =
      if id == fst model then 
        (id, with)
      else
        model
  in
    List.map replace models

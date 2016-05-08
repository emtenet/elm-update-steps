import Update.App
import CounterList


main =
  Update.App.program
    { init = CounterList.init
    , view = CounterList.view
    , update = CounterList.update
    }

import Update.App
import CounterPair


main =
  Update.App.program
    { init = CounterPair.init 0 0
    , view = CounterPair.view
    , update = CounterPair.update
    }

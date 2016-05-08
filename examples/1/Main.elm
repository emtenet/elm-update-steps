import Update.App
import Counter


main =
  Update.App.program
    { init = Counter.init 0
    , view = Counter.view
    , update = Counter.update
    }

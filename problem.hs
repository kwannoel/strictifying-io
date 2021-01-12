import           Control.Monad (forever)

main :: IO ()
main = do
    src <- readFile "./test"
    runKeyPressListener src

runKeyPressListener :: String -> IO ()
runKeyPressListener src = forever $ do
    i <- getLine
    case i of
        "READ" -> print src
        _      -> print "Unrecognized command"

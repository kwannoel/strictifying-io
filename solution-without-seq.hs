import           Control.Monad (forever)

main :: IO ()
main = do
    src <- readFile "./test"
    src `deepseq` runKeyPressListener src

runKeyPressListener :: String -> IO ()
runKeyPressListener src = forever $ do
    i <- getLine
    case i of
        "READ" -> print src
        _      -> print "Unrecognized command"

-- | Using case matching to force evaluation
deepseq :: [a] -> b -> b
deepseq xs b = case xs of
    []     -> b
    (x:xs) -> case x of
                  _ -> deepseq xs b

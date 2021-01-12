# Making IO Strict

## Scenario

We have a program which should read a large configuration file upon startup, and then starts running he program... except it doesn't.

``` haskell
main :: IO ()
main = do
    config <- getLargeConfig
    startServer config [routeHandler]
    
-- | Server with a single route
startServer :: Config -> (Text -> Config -> Text) -> IO ()
startServer config rs = forever $ do
    r <- getReq
    routeHandler r config
    
data Config =
    { networkUri :: Text
    , a :: ...
    , b :: ...
    , c :: ...
    , d :: ...
    , ...
    }
    
routeHandler :: Text -> Config -> IO Response
routeHandler req Config{..} = sendResponse networkUri
```

This is because only when the route gets triggered, the data dependency on `Config{..}` forces evaluation of `config` and in turn the `getLargeConfig` action.

## Reproduce problem

Create a large file, for which IO is expensive:
``` sh
# ~100MB file
make test
```

Whenever there is input `"READ"`, read the entire file.

Other string, invalid

##  Solution

Create initialization data dependency on config for subsequent IO actions.

## Observation

For `problem.hs`, lazy IO results in the READ op not being executed until we type "READ".

For the solutions, after waiting a while, we will get READ op response instantly.

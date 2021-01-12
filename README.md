# Making IO Strict

## Scenario

We have a program which should read a large configuration file upon startup, and then starts running he program... except it doesn't.

``` haskell
main :: IO ()
main = do
    config <- getLargeConfig
    startServer $! config [routeHandler]
    
startServer :: Config -> [Routes] -> IO ()
startServer config rs = do
    
data Config =
    { networkUri :: Text
    , a :: ...
    , b :: ...
    , c :: ...
    , d :: ...
    }
    
routeHandler :: Text -> Config -> Text
routeHandler req Config{..} = return networkUri
```

This is because only when the route gets triggered, the data dependency on `Config{..}` forces evaluation of `config` and in turn the `getLargeConfig` action.

We will reproduce this & provide a solution

## Reproduce problem

Create a large file, for which IO is expensive:
``` sh
# ~100MB file
make test
```

Whenever there is keypress `'r'`, read the entire file.

Other keypress -> do nothing.

##  Solution

Create initialization data dependency by running `seq` on subsequent IO.

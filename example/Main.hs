{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import Control.Concurrent
import Data.String.Interpolate
import System.FSNotify
import System.FilePath

main :: IO ()
main = do
    let dir = "/tmp/watched"
    let conf = defaultConfig
    withManagerConf conf $ \mgr -> do
      putStrLn [i|Watching tree #{dir}|]
      stop <- watchTree mgr dir (const True) $ \ev -> do
        putStrLn [i|Got event: #{ev}|]
      putStrLn [i|Waiting 3s|]
      threadDelay 3_000_000
      putStrLn [i|Writing #{dir}/bar|]
      writeFile (dir </> "bar") "asdf"
      putStrLn [i|Waiting 3s|]
      threadDelay 3_000_000
      putStrLn [i|Stopping watch|]
      stop

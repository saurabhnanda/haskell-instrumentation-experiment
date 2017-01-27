{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}

module InstrumentedOpaleye
  (
    module Opaleye
  , module Instrumented
  )
where

import Instrumented
import Opaleye hiding (runQuery)


-- longRunningIO :: IO ()
-- longRunningIO = return ()

-- instrumentIO :: TChan InstrumentationData -> IO ()
-- instrumentIO chan = do
--   st <- getCurrentTime
--   result <- longRunningIO
--   en <- getCurrentTime
--   atomically $ writeTChan chan InstrumentationData{instrStart=st, instrEnd=en, instrSql=Just "TODO"}
--   return result

-- sampleUsage = do
--   chan <- createChan
--   instrumentIO chan
--   where
--     createChan :: IO (TChan InstrumentationData)
--     createChan = atomically newBroadcastTChan


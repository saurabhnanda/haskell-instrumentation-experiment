{-# LANGUAGE FlexibleContexts #-}

module Instrumented
  (
    Instrumented.runQuery
  ) where

import Opaleye
import qualified Database.PostgreSQL.Simple as PGS
import Data.Profunctor.Product.Default
import Data.Text as T
import InstrumentedCore

runQuery :: (Default Unpackspec columns columns, Default QueryRunner columns haskells, HasInstrumentation m) => PGS.Connection -> Query columns -> m [haskells]
runQuery conn q = do
  st <- liftIO getCurrentTime
  result <- liftIO $ Opaleye.runQuery conn q
  en <- liftIO $ getCurrentTime
  logInstrumentationData InstrumentationData{instrStart=st, instrEnd=en, instrPayload=InstrumentedCore.Sql (showSql q)}
  return result

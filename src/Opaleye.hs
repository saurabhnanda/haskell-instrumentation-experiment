{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}

module Opaleye
  (
    module Opaleye
  , module OpaleyeOriginal
  )
where

import qualified Database.PostgreSQL.Simple as PGS
import Data.Profunctor.Product.Default
import OpaleyeOriginal
import qualified "opaleye" Opaleye as O
import InstrumentedCore

runQuery :: (Default Unpackspec columns columns, Default QueryRunner columns haskells, HasInstrumentation m) => PGS.Connection -> Query columns -> m [haskells]
runQuery conn q = do
  st <- liftIO getCurrentTime
  result <- liftIO $ O.runQuery conn q
  en <- liftIO $ getCurrentTime
  logInstrumentationData InstrumentationData{instrStart=st, instrEnd=en, instrPayload=InstrumentedCore.Sql (showSql q)}
  return result

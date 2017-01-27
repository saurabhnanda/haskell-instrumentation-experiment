module InstrumentedCore
  (
    module Data.Time
  , module Data.Time.Clock
  , module InstrumentedCore
  , module Control.Monad.IO.Class
  )
where

import Data.Time(getCurrentTime, UTCTime)
import Data.Time.Clock(diffUTCTime)
import Control.Monad.IO.Class (liftIO, MonadIO)


data InstrumentationPayload =
  Sql (Maybe String)
  | Render

data InstrumentationData = InstrumentationData
  {
    instrStart :: UTCTime
  , instrEnd :: UTCTime
  , instrPayload :: InstrumentationPayload
  }

instance Show InstrumentationData where
  show x = "[" ++ (show diff) ++ "] " ++ (dataType $ instrPayload x)
    where
      diff = diffUTCTime (instrEnd x) (instrStart x)
      dataType (Sql x) = "SQL"
      dataType (Render) = "Render"

class (MonadIO m) => HasInstrumentation m where
  logInstrumentationData :: InstrumentationData -> m ()

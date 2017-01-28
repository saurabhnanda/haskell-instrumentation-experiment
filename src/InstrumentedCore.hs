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
import GHC.Stack (CallStack, prettyCallStack)
import Network.HTTP.Types.Method (Method(..))
import Data.ByteString as BS
import Data.String.Conv
-- import Network.Wai

type URL = BS.ByteString

data InstrumentationPayload =
  Sql (Maybe String)
  | LucidFile FilePath
  | LucidRender CallStack
  | ScottyAction Method URL -- todo unable to destructure RoutePattern
  | ScottyRender

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

      dataType :: InstrumentationPayload -> String
      dataType (Sql x) = "SQL"
      dataType (LucidFile filepath) = "Render file: " ++ (show filepath)
      dataType (LucidRender stack) = "Render Lucid's HtmlT: " ++ (prettyCallStack stack)
      dataType (ScottyAction method url) = "Scotty action: " ++ (show method) ++ " " ++ (toS url)
      dataType (ScottyRender) = "Scotty render"

--       showRoute 
class (MonadIO m) => HasInstrumentation m where
  logInstrumentationData :: InstrumentationData -> m ()

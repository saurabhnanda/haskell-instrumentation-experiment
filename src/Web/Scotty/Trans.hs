{-# LANGUAGE FlexibleContexts #-}

module Web.Scotty.Trans
  (
    module Web.Scotty.Trans
  , module Web.Scotty.TransOriginal
  )
where

import Web.Scotty.TransOriginal
import qualified "scotty" Web.Scotty.Trans as S
import InstrumentedCore
import Control.Monad.Trans.Class(lift)
import Network.HTTP.Types.Method (StdMethod(..))
import Network.Wai (requestMethod, rawPathInfo, rawQueryString)

instrumentedAction original action = original action_
  where
    action_ = do
      st <- liftIO $ getCurrentTime
      result <- action
      en <- liftIO $ getCurrentTime
      req <- request
      lift $ logInstrumentationData InstrumentationData{instrStart=st, instrEnd=en, instrPayload=ScottyAction (requestMethod req) (rawPathInfo req)}
      return result

routePayload method route = ScottyAction method route
get route action = instrumentedAction (S.get route) action 
post route action = instrumentedAction (S.post route) action
put route action = instrumentedAction (S.put route) action
delete route action = instrumentedAction (S.delete route) action 
patch route action = instrumentedAction (S.patch route) action 
options route action = instrumentedAction (S.options route) action 
addroute method route action = instrumentedAction (S.addroute method route) action

instrumentedRender original = do
  st <- liftIO $ getCurrentTime
  result <- original
  en <- liftIO $ getCurrentTime
  logInstrumentationData InstrumentationData{instrStart=st, instrEnd=en, instrPayload=ScottyRender}
  return result

text inp = instrumentedRender (S.text inp)
html inp = instrumentedRender (S.html inp)
file inp = instrumentedRender (S.file inp)
json inp = instrumentedRender (S.json inp)
stream inp = instrumentedRender (S.stream inp)
raw inp = instrumentedRender (S.raw inp)

{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE PackageImports #-}

module Web.Scotty.Trans
  (
    module OS
  , get
  , post
  , put
  , delete
  , patch
  , options
  , addroute
  )
where

import qualified "scotty" Web.Scotty.Trans as OS hiding (get, post, put, delete, patch, options, addroute)
import qualified "scotty" Web.Scotty.Trans as S
import InstrumentedCore
import Control.Monad.Trans.Class(lift)

instrumentedAction original action = original action_
  where
    action_ = do
      st <- liftIO $ getCurrentTime
      result <- action
      en <- liftIO $ getCurrentTime
      logInstrumentationData InstrumentationData{instrStart=st, instrEnd=en, instrPayload=Render}
      return result


get route action = instrumentedAction (S.get route) action
post route action = instrumentedAction (S.post route) action
put route action = instrumentedAction (S.put route) action
delete route action = instrumentedAction (S.delete route) action
patch route action = instrumentedAction (S.patch route) action
options route action = instrumentedAction (S.options route) action
addroute method route action = instrumentedAction (S.addroute method route) action


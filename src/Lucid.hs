module Lucid
  (
    module Lucid
  , module LucidOriginal
  )
where

import LucidOriginal
import qualified "lucid" Lucid as L
import InstrumentedCore
import GHC.Stack(callStack)

instrumentedRender original html = do
  st <- liftIO getCurrentTime
  res <- original html
  en <- liftIO getCurrentTime
  logInstrumentationData InstrumentationData{instrStart=st, instrEnd=en, instrPayload=LucidRender callStack}
  return res


renderTextT html = instrumentedRender L.renderTextT html
renderBST html = instrumentedRender L.renderBST html
renderToFile filepath html =  do
  st <- liftIO getCurrentTime
  res <- liftIO $ L.renderToFile filepath html
  en <- liftIO getCurrentTime
  logInstrumentationData InstrumentationData{instrStart=st, instrEnd=en, instrPayload=LucidFile filepath}
  return res
  -- instrumentedRender (liftA2 L.renderToFile filepath) html

execHtmlT html = instrumentedRender L.execHtmlT html
evalHtmlT html = instrumentedRender L.evalHtmlT html
runHtmlT html = instrumentedRender L.runHtmlT html

{-# LANGUAGE FlexibleContexts #-}

module Web.Scotty.TransOriginal
  (
    module Web.Scotty.Trans
  )
where

import "scotty" Web.Scotty.Trans hiding (get, post, put, delete, patch, options, addroute, text, html, file, json, stream, raw)

{-# LANGUAGE OverloadedStrings #-}
module Tila.App
  (run)
where

import Tila.Prelude

import Tila.App.Routes


initContext :: Int -> IO TilaContext
initContext port = do
  (_, modLogg) <- newLogger $ LogStderr defaultBufSize
  metrStore <- serverMetricStore <$> forkMetricsServer "0.0.0.0" port
  modMetr <- newMetricsWith metrStore
  return (modLogg, modMetr)

run :: Int -> IO ()
run port = do
  ctx <- initContext port
  defWaiMain $ magicbaneApp (Proxy :: Proxy Routes) EmptyContext ctx routes

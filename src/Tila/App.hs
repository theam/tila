{-# LANGUAGE OverloadedStrings #-}
module Tila.App
  (run)
where

import Tila.Prelude

import Tila.App.Routes

initContext :: Int
            -> IO TilaContext
initContext port = do
  let host = "localhost"
  let port = 5432
  let user = "postgresql"
  let password = "secret"
  let dbname = "sialbb"
  let poolCapacity = 10
  let connString =
        " host=" ++ host
        " port=" ++ port
        " user=" ++ user
        " password=" ++ password
        " dbname=" ++ dbname

  pool <- runStderrLoggingT $
    createPostgresqlPool connString poolCapacity
  return $ TilaContext
    { tilapool = pool
    }

run :: Int -> IO ()
run port = do
  ctx <- initContext port
  defWaiMain $ magicbaneApp (Proxy :: Proxy Routes) EmptyContext ctx routes

{-# LANGUAGE OverloadedStrings #-}
module Tila.App
  (Tila.App.run)
where

import Tila.Prelude
import Control.Category ((<<<), (>>>))
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BS

import Database.Persist.Postgresql
import Network.Wai.Handler.Warp as Warp (run)
import Servant.Server

import Tila.App.Routes
import Tila.App.Home.Model
import qualified Tila.App.Home.Models.TilPost as TilPost


app :: AppConfig -> Application
app cfg = serve (Proxy :: Proxy Routes) (appToServer cfg)

appToServer :: AppConfig -> Server Routes
appToServer cfg = enter (convertApp cfg >>> NT Handler) routes

convertApp :: AppConfig -> AppT monad :~> ExceptT ServantErr monad
convertApp cfg = runReaderTNat cfg <<< NT runApp


makePool :: ByteString -> Int -> IO ConnectionPool
makePool connString poolCapacity = runStdoutLoggingT $
  createPostgresqlPool connString poolCapacity


initContext :: Int
            -> IO AppConfig
initContext _ = do
  let host = "localhost"
  let port = 5432
  let user = "postgres"
  let password = "secret"
  let dbname = "sialbb"
  let poolCapacity = 10
  let connString =
        " host=" <> host <>
        " port=" <> show port <>
        " user=" <> user <>
        " password=" <> password <>
        " dbname=" <> dbname

  pool <- makePool (BS.pack connString) poolCapacity
  runSqlPool TilPost.doMigrations pool
  return $ AppConfig
    { tilaPool = pool
    , tilaEnvironment = Dev
    }

run :: Int -> IO ()
run port = do
  ctx <- initContext port
  Warp.run port $
    app ctx

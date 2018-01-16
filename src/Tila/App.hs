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
import Servant.Utils.StaticFiles
import Web.Heroku
import qualified Data.Text as Text

import Tila.App.Routes
import qualified Tila.App.Home.Models.TilPost as TilPost

type AppAPI = Routes
  :<|> "static" :> Raw

app :: AppConfig -> Application
app cfg = serve (Proxy :: Proxy AppAPI) (appToServer cfg)

appToServer :: AppConfig -> Server AppAPI
appToServer cfg = enter (convertApp cfg >>> NT Handler) routes :<|> serveDirectoryWebApp "static"

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

herokuInitContext :: IO AppConfig
herokuInitContext = do
  conn <- dbConnParams
  let poolCapacity = 10
  let connString = unwords $ map (\(k, v) -> Text.unpack k <> "=" <> Text.unpack v) conn
  pool <- makePool (BS.pack connString) poolCapacity
  runSqlPool TilPost.doMigrations pool
  return $ AppConfig
    { tilaPool = pool
    , tilaEnvironment = Dev
    }


run :: Int -> IO ()
run port = do
  putStrLn $ "Running app on port " <> show port
  ctx <- herokuInitContext
  Warp.run port $
    app ctx

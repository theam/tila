{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Tila.Prelude

import Text.Read
import System.Environment

import qualified Tila.App as App

getPort :: IO Int
getPort = do
  portString <- lookupEnv "PORT"
  let port = portString >>= readMaybe
  return $ maybe 8080 id port


getDeployEnvironment :: IO DeployEnvironment
getDeployEnvironment = do
  envString <- lookupEnv "TILA_ENV"
  let env = envString >>= readMaybe
  return $ maybe Dev id env


main :: IO ()
main = do
  port <- getPort
  env <- getDeployEnvironment
  App.run env port

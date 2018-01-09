{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Tila.Prelude

import Text.Read
import System.Environment

import qualified Tila.App as App

main :: IO ()
main = do
  portString <- lookupEnv "EKG_PORT"
  case portString >>= readMaybe of
    Just (port :: Int)
      -> App.run port
    Nothing
      -> App.run 8080

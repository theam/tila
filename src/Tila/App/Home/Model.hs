{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE GADTs #-}
module Tila.App.Home.Model where

import Tila.Prelude

import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH
import Control.Monad.IO.Class (liftIO)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
TilPost
  postTitle Text
  postContent Text
  postAuthor Text
  deriving Show
|]

data Home = Home
  { homePosts :: [TilPost]
  }

doMigrations :: SqlPersist IO ()
doMigrations = runMigration migrateAll

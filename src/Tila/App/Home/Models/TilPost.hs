module Tila.App.Home.Models.TilPost where

import Tila.Prelude

import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH
import Control.Monad.IO.Class (liftIO)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
TilPost
  postContent Text
  postAuthor Text
  postTag Text
  deriving Show
|]

doMigrations :: SqlPersist IO ()
doMigrations = runMigration migrateAll


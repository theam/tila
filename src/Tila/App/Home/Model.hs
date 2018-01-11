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

mkPersist sqlSettings [persistLowerCase|
TilPost
  postTitle String
  postContent String
  postAuthor String
  deriving Show
|]

data Home = Home
  { homePosts :: [TilPost]
  }

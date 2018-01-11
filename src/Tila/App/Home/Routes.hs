module Tila.App.Home.Routes where

import Tila.Prelude

import Database.Persist
import Database.Persist.Postgresql

import Tila.App.Home.Model
import qualified Tila.App.Home.Models.TilPost as TilPost
import Tila.App.Home.Models.TilPost (TilPost)
import Tila.App.Home.View ()

type Routes
  = Get '[HTML] Home

routes = getHome


getHome :: App Home
getHome = do
  posts <- getPosts
  liftIO . putStrLn $ "Posts count: " <> (show $ length posts)
  return (Home $ [TilPost.TilPost "Title" "Content" "Author"])
 where
  getPosts :: App [Entity TilPost]
  getPosts = runDb (selectList [] [])

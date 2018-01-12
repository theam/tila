module Tila.App.Home.Routes
  (Routes, routes)
where

import Tila.Prelude

import Control.Lens
import qualified Data.Text as Text
import qualified Data.Vector as Vector
import Database.Persist
import Database.Persist.Postgresql
import GitHub.Endpoints.Repos.Contents
import qualified Network.Wreq as Wreq

import Tila.App.Home.Model
import qualified Tila.App.Home.Models.TilPost as TilPost
import Tila.App.Home.Models.TilPost (TilPost(..))
import Tila.App.Home.View ()

type Routes
  = Get '[HTML] Home

routes = getHome


getHome :: App Home
getHome = do
  dirs <- githubDirectories
  posts <- makePosts dirs
  return (Home posts)


dbPosts :: App [Entity TilPost]
dbPosts = runDb (selectList [] [])


githubDirectories :: App [ContentItem]
githubDirectories = retrieve "" >>= \case
  Right (ContentDirectory files) ->
    files
    & Vector.filter (\file -> contentItemType file == ItemDir)
    & Vector.toList
    & return
  _ ->
    return []


makePosts :: [ContentItem] -> App [TilPost]
makePosts dirs = do
  posts <- mapM tilPostsFromDir dirs
  return $ concat posts

tilPostsFromDir :: ContentItem -> App [TilPost]
tilPostsFromDir dir = do
  let tag = contentName $ contentItemInfo dir
  let path = contentPath $ contentItemInfo dir
  files <- retrieve path >>= \case
    Right (ContentDirectory files) ->
      files
      & Vector.filter (\file -> contentItemType file == ItemFile)
      & Vector.toList
      & return
    _ ->
      return []
  maybePosts <- mapM (tilPostFromFile tag) files
  return $ catMaybes maybePosts

tilPostFromFile :: Text -> ContentItem -> App (Maybe TilPost)
tilPostFromFile tag item = do
  retrieveFileContent (Text.unpack . contentPath $ contentItemInfo item) >>= \case
    Just c ->
      return (Just $ TilPost c "unknown" tag)
    _ ->
      return Nothing

retrieve :: Text -> App (Either Error Content)
retrieve path = liftIO $ contentsFor "theam" "til" path Nothing

retrieveFileContent :: String -> App (Maybe Text)
retrieveFileContent path = do
  r <- liftIO $ Wreq.get url
  return . Just . Text.pack . show $ r ^. Wreq.responseBody
 where
  url = "https://raw.githubusercontent.com/theam/til/master/" <> path

module Tila.App.Home.Controllers.Page
  ( controller )
where

import Tila.Prelude

import Control.Lens
import qualified Data.Text as Text
import qualified Data.Vector as Vector
import Database.Persist
import Database.Persist.Postgresql
import GitHub.Endpoints.Repos.Contents
import qualified Network.Wreq as Wreq

import Tila.App.Home.Models.Page
import qualified Tila.App.Home.Models.TilPost as TilPost
import Tila.App.Home.Models.TilPost (TilPost(..))

controller :: App Page
controller = do
  dirs <- githubDirectories
  posts <- makePosts dirs
  return (Page posts)


githubDirectories :: App [ContentItem]
githubDirectories = do
  items <- retrieve ""
  return (either (const []) (filterWithItemType ItemDir))


makePosts :: [ContentItem] -> App [TilPost]
makePosts dirs = do
  posts <- mapM tilPostsFromDir dirs
  return $ concat posts

tilPostsFromDir :: ContentItem -> App [TilPost]
tilPostsFromDir dir = do
  let tag = contentName $ contentItemInfo dir
  let path = contentPath $ contentItemInfo dir
  items <- retrieve path
  let files = either (const []) (filterWithItemType ItemFile)
  maybePosts <- mapM (tilPostFromFile tag) files
  return $ catMaybes maybePosts

tilPostFromFile :: Text -> ContentItem -> App (Maybe TilPost)
tilPostFromFile tag item = do
  content <- retrieveFileContent (Text.unpack . contentPath $ contentItemInfo item)
  return (fmap (makePost tag) content)
 where
  makePost tag c = TilPost c "unknown" tag

filterWithItemType :: ContentItemType -> Vector.Vector ContentItem -> [ContentItem]
filterWithItemType itemType items =
  items
  & Vector.filter (\item -> contentItemType item == itemType)
  & Vector.toList

retrieve :: Text -> App (Either Error Content)
retrieve path = liftIO $ contentsFor "theam" "til" path Nothing

retrieveFileContent :: String -> App (Maybe Text)
retrieveFileContent path = do
  r <- liftIO $ Wreq.get url
  return . Just . Text.pack . show $ r ^. Wreq.responseBody
 where
  url = "https://raw.githubusercontent.com/theam/til/master/" <> path


-- return $ either (filterWithItemType ItemDir) (const [])

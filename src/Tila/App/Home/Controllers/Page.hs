module Tila.App.Home.Controllers.Page
  ( controller )
where

import Tila.Prelude

import Control.Lens
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
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
  auth <- asks tilaAuth
  items <- retrieveDirectoryItems auth ""
  return (withLeftAsEmptyList (filterWithItemType ItemDir) items)


makePosts :: [ContentItem] -> App [TilPost]
makePosts dirs = do
  posts <- mapM tilPostsFromDir dirs
  return $ concat posts


tilPostsFromDir :: ContentItem -> App [TilPost]
tilPostsFromDir dir = do
  auth <- asks tilaAuth
  let tag = contentName $ contentItemInfo dir
  let path = contentPath $ contentItemInfo dir
  items <- retrieveDirectoryItems auth path
  let files = withLeftAsEmptyList (filterWithItemType ItemFile) items
  maybePosts <- mapM (tilPostFromFile tag) files
  return $ catMaybes maybePosts


tilPostFromFile :: Text -> ContentItem -> App (Maybe TilPost)
tilPostFromFile tag item = do
  content <- retrieveFileContent (Text.unpack . contentPath $ contentItemInfo item)
  return (fmap makePost content)
 where
  makePost c = TilPost (Text.unlines . drop 2 $ Text.lines c) (head $ Text.lines c) tag


filterWithItemType :: ContentItemType -> Vector ContentItem -> [ContentItem]
filterWithItemType itemType items =
  items
  & Vector.filter (\item -> contentItemType item == itemType)
  & Vector.toList


retrieveDirectoryItems :: Maybe Auth -> Text -> App (Either Error (Vector ContentItem))
retrieveDirectoryItems auth path = do
  contents <- retrieve auth path
  return $ fmap extractDirContents contents
 where
  retrieve auth' path' = liftIO $ contentsFor' auth' "theam" "til" path' Nothing
  extractDirContents (ContentDirectory c) = c
  extractDirContents _ = Vector.empty


withLeftAsEmptyList :: (b -> [c]) -> Either a b -> [c]
withLeftAsEmptyList f = either (const []) f


retrieveFileContent :: String -> App (Maybe Text)
retrieveFileContent path = do
  r <- liftIO $ Wreq.get url
  return . Just . Text.decodeUtf8 . LBS.toStrict $ r ^. Wreq.responseBody
 where
  url = "https://raw.githubusercontent.com/theam/til/master/" <> path



module Tila.App.Home.Model where

import Tila.Prelude

data Post = Post
  { postTitle   :: Text
  , postContent :: Text
  , postAuthor  :: Text
  }

data Home = Home
  { homePosts :: [Post]
  }

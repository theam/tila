module Tila.App.Home.Models.Page where

import Tila.App.Home.Models.TilPost

data Page = Page
  { pagePosts :: [TilPost]
  }


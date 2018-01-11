module Tila.App.Home.Model where

import Tila.Prelude
import Tila.App.Home.Models.TilPost

data Home = Home
  { homePosts :: [TilPost]
  }


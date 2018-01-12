module Tila.App.Home.View where

import Tila.Prelude

import Lucid

import Tila.App.Home.Model
import Tila.App.Home.Models.TilPost


instance ToHtml Home where
  toHtmlRaw = toHtml
  toHtml content =
    body_ $ mapM_ (p_ . toHtml . tilPostPostContent) (homePosts content)


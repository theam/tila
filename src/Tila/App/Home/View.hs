module Tila.App.Home.View where

import Tila.Prelude

import Lucid

import Tila.App.Home.Models.Page
import Tila.App.Home.Models.TilPost


instance ToHtml Page where
  toHtmlRaw = toHtml
  toHtml page =
    body_ $ mapM_ (p_ . toHtml . tilPostPostContent) (pagePosts page)


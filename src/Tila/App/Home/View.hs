module Tila.App.Home.View where

import Tila.Prelude

import Cheapskate
import Cheapskate.Lucid
import Lucid

import Tila.App.Home.Models.Page
import Tila.App.Home.Models.TilPost


instance ToHtml Page where
  toHtmlRaw = toHtml
  toHtml page =
    body_ $
      mapM_ (renderMarkdown . tilPostPostContent) (pagePosts page)


renderMarkdown :: Monad m => Text -> HtmlT m ()
renderMarkdown = renderDoc . markdown def

module Tila.App.Home.View where

import Tila.Prelude

import Cheapskate
import Cheapskate.Lucid
import Lucid

import Tila.App.Home.Models.Page
import Tila.App.Home.Models.TilPost


instance ToHtml Page where
  toHtmlRaw = toHtml
  toHtml page = do
    head_ $ do
      link_
        [ rel_ "stylesheet"
        , href_ "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css"
        ]
      script_
        [ src_ "https://code.jquery.com/jquery-3.2.1.slim.min.js" ]
        ""
      script_
        [ src_ "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" ]
        ""
      script_
        [ src_ "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js" ]
        ""
    body_ $
      div_ [class_ "container"] $ do
        div_ [class_ "row"] $ do
          div_ [class_ "text-center"] $ do
            h1_ "Today I Learned"
        renderPosts page

renderPosts :: Monad m => Page -> HtmlT m ()
renderPosts page =
  mapM_
  wrapInCard
  (pagePosts page)


wrapInCard :: Monad m => TilPost -> HtmlT m ()
wrapInCard post =
  div_ [class_ "row"] $ do
    div_ [class_ "col-6 mx-auto"] $ do
      div_ [class_ "text-center"] $ do
        div_ [class_ "card post-card"] $ do
          div_ [class_ "card-block"] $
            div_ [class_ "container"] $
              renderMarkdown $ tilPostPostContent post

          div_ [class_ "card-footer text-muted post-footer"] $ do

            div_ [class_ "post-tag"] $
              "#" <> (toHtml $ tilPostPostTag post)

            div_ [class_ "post-author"] $
              "Written by: " <> (toHtml $ tilPostPostAuthor post)


renderMarkdown :: Monad m => Text -> HtmlT m ()
renderMarkdown = renderDoc . markdown def

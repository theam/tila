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
      title_ "Today I Learned - Theam"
      link_
        [ rel_ "stylesheet"
        , href_ "https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css"
        ]
      link_
        [ rel_ "stylesheet"
        , href_ "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css"
        ]
      link_
        [ rel_ "stylesheet"
        , href_ "static/highlight/styles/github.css"
        ]
      link_
        [ rel_ "stylesheet"
        , href_ "https://fonts.googleapis.com/css?family=Titillium+Web:400,700"
        ]
      link_
        [ rel_ "stylesheet"
        , href_ "static/style.css"
        ]
      script_
        [ src_ "https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js" ]
        ""
      script_
        [ src_ "https://code.jquery.com/jquery-3.2.1.slim.min.js" ]
        ""
      script_
        [ src_ "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" ]
        ""
      script_
        [ src_ "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js" ]
        ""
      script_
        [ src_ "static/highlight/highlight.pack.js" ]
        ""
      script_
        [ src_ "static/til.js" ]
        ""
    body_ $
      div_ [class_ "container"] $ do
        div_ [class_ "row"] $ do
          div_ [class_ "col-10 mx-auto"] $ do
            div_ [class_ "header text-center"] $ do
              h1_ [class_ "logo" ]$ do
                img_
                  [alt_ "Theam logo"
                  , src_ "http://theam.io/logo_theam@2x.png"
                  , width_ "400"
                  , height_ "132"
                  ]
              h1_ "Today I Learned"
          div_ [class_ "col-8 mx-auto"] $ do
            a_ [ class_ "float-right", href_ "#", onclick_ "openNewFile()" ] $ do
              img_ [ class_ "top-button", src_ "static/img/pencil-256.png", style_ "height:25px;"]
        renderPosts page


renderPosts :: Monad m => Page -> HtmlT m ()
renderPosts page =
  mapM_
  wrapInCard
  (pagePosts page)


wrapInCard :: Monad m => TilPost -> HtmlT m ()
wrapInCard post =
  div_ [class_ "row"] $ do
    div_ [class_ "col-8 mx-auto"] $ do
      div_ [class_ ""] $ do
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

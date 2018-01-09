module Tila.App.Home.View where

import Lucid

import Tila.App.Home.Model


instance ToHtml Home where
  toHtmlRaw = toHtml
  toHtml _ =
      "Hello world"


module Tila.App.Home.Routes where

import Tila.Prelude
import Tila.App.Home.Model
import Tila.App.Home.View ()


type Routes
  = Get '[HTML] Home

routes = getHome

getHome :: TilaApp Home
getHome = return (Home $ [TilPost "Title" "Content" "Author"])


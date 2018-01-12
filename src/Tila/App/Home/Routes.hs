module Tila.App.Home.Routes
  (Routes, routes)
where

import Tila.Prelude

import Tila.App.Home.Models.Page as Page
import Tila.App.Home.Controllers.Page as Page
import Tila.App.Home.View ()

type Routes
  = Get '[HTML] Page

routes = Page.controller


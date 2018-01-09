module Tila.Prelude
  ( module Export
  , TilaContext
  , TilaApp
  , (&)
  )
where

import Magicbane as Export
import Servant.HTML.Lucid as Export
import Data.Function ((&))


type TilaContext =
  ( ModLogger
  , ModMetrics
  )

type TilaApp = MagicbaneApp TilaContext


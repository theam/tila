module Tila.Prelude
  ( module Export
  , TilaContext
  , TilaApp
  , (&)
  )
where

import Servant.HTML.Lucid as Export
import Data.Function ((&))
import Data.Pool
import Database.Persist.Sql


data TilaContext = TilaContext
  { tilaPool :: Pool SqlBackend
  }

type TilaApp = ReaderT TilaContext (EitherT ServantErr IO)

readerToEither :: TilaContext -> TilaApp :~> EitherT ServantErr IO
readerToEither ctx = Nat $ \x -> runReaderT x cfg


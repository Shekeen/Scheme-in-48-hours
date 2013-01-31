module Scheme.Aux where

import Control.Monad

until_ :: Monad m => (a -> Bool) -> m a -> (a -> m ()) -> m ()
until_ pred prompt action = do
       result <- prompt
       if pred result
          then return ()
          else action result >> until_ pred prompt action

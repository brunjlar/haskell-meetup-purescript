module Dom where

import Control.Monad.Eff
import Data.Int
import Data.Maybe
import Prelude

foreign import data DOM :: !

foreign import getValueById :: forall eff. String -> Eff (dom :: DOM | eff) (Maybe String)

getIntValueById :: forall eff. String -> Eff (dom :: DOM | eff) (Maybe Int)
getIntValueById id = do
    ms <- getValueById id
    return $ case ms of
        Nothing -> Nothing
        Just s  -> fromString s
        
foreign import setValueById :: forall eff. String -> String -> Eff (dom :: DOM | eff) Unit
        
foreign import onInput :: forall eff. String -> Eff (dom :: DOM | eff) Unit -> Eff (dom :: DOM | eff) Unit

foreign import onClick :: forall eff. String -> Eff (dom :: DOM | eff) Unit -> Eff (dom :: DOM | eff) Unit
module Dom where

import Control.Monad.Eff
import Data.Int
import Data.Maybe
import Prelude

foreign import data DOM :: !

type EffDom eff a = Eff (dom :: DOM | eff) a

foreign import data DomElement :: *

foreign import body :: forall e. EffDom e DomElement

foreign import getElementById :: forall e. String -> EffDom e (Maybe DomElement)

foreign import createElement :: forall e. String -> EffDom e DomElement

foreign import createTextNode :: forall e. String -> EffDom e DomElement

foreign import appendChild :: forall e. DomElement -> DomElement -> EffDom e Unit

foreign import removeChild :: forall e. DomElement -> DomElement -> EffDom e Unit

foreign import getAttribute :: forall e. DomElement -> String -> EffDom e (Maybe String)

foreign import setAttribute :: forall e. DomElement -> String -> String -> EffDom e Unit

foreign import onInput :: forall e. String -> EffDom e Unit -> EffDom e Unit

foreign import onClick :: forall e. String -> EffDom e Unit -> EffDom e Unit

foreign import getValue :: forall e. DomElement -> EffDom e (Maybe String)

foreign import setValue :: forall e. DomElement -> String -> EffDom e Unit

getValueById :: forall e. String -> EffDom e (Maybe String)
getValueById id = getElementById id >>= maybe (return Nothing) getValue

getIntValueById :: forall e. String -> EffDom e (Maybe Int)
getIntValueById id = getValueById id >>= maybe Nothing fromString >>> return
        
setValueById :: forall e. String -> String -> EffDom e Unit
setValueById id value = getElementById id >>= maybe (return unit) (flip setValue value)
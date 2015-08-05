module Dom where

import Prelude
import Control.Monad.Eff
import Data.Int
import Data.Maybe

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

foreign import onInput :: forall e a. DomElement -> EffDom e Unit -> EffDom e Unit

foreign import onClick :: forall e a. DomElement -> EffDom e Unit -> EffDom e Unit

foreign import getValue :: forall e. DomElement -> EffDom e (Maybe String)

foreign import setValue :: forall e. DomElement -> String -> EffDom e Unit

button :: forall e. String -> EffDom e Unit -> EffDom e DomElement
button text handler = do
    b <- createElement "button"
    setAttribute b "type" "button"
    t <- createTextNode text
    b `appendChild` t
    b `onClick` handler
    return b
    
removeClick :: forall e. DomElement -> EffDom e Unit
removeClick b = b `onClick` (return unit)
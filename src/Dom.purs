module Dom (
    DOM(..),
    EffDom(..),
    DomElement(..),
    body,
    getElementById,
    createElement,
    createTextNode,
    appendChild,
    removeChild,
    getAttribute,
    setAttribute,
    getValue,
    setValue,
    onClick,
    onInput,
    button,
    removeClick
) where

import Prelude
import Control.Monad.Eff

import Data.Function
import Data.Maybe

foreign import data DOM :: !

type EffDom eff a = Eff (dom :: DOM | eff) a

foreign import data DomElement :: *

foreign import body :: forall e. EffDom e DomElement

foreign import getElementByIdImpl :: forall e. Fn3 (DomElement -> Maybe DomElement) (Maybe DomElement) String (EffDom e (Maybe DomElement))

getElementById :: forall e. String -> EffDom e (Maybe DomElement)
getElementById = runFn3 getElementByIdImpl Just Nothing

foreign import createElement :: forall e. String -> EffDom e DomElement

foreign import createTextNode :: forall e. String -> EffDom e DomElement

foreign import appendChildImpl :: forall e. Fn2 DomElement DomElement (EffDom e Unit)

appendChild :: forall e. DomElement -> DomElement -> EffDom e Unit
appendChild = runFn2 appendChildImpl

foreign import removeChildImpl :: forall e. Fn2 DomElement DomElement (EffDom e Unit)

removeChild :: forall e. DomElement -> DomElement -> EffDom e Unit
removeChild = runFn2 removeChildImpl

foreign import getAttributeImpl :: forall e. Fn4 (String -> Maybe String) (Maybe String) DomElement String (EffDom e (Maybe String))

getAttribute :: forall e. DomElement -> String -> EffDom e (Maybe String)
getAttribute = runFn4 getAttributeImpl Just Nothing

foreign import setAttributeImpl :: forall e. Fn3 DomElement String String (EffDom e Unit)

setAttribute :: forall e. DomElement -> String -> String -> EffDom e Unit
setAttribute = runFn3 setAttributeImpl

foreign import getValueImpl :: forall e. Fn3 (String -> Maybe String) (Maybe String) DomElement (EffDom e (Maybe String))

getValue :: forall e. DomElement -> EffDom e (Maybe String)
getValue = runFn3 getValueImpl Just Nothing

foreign import setValueImpl :: forall e. Fn2 DomElement String (EffDom e Unit)

setValue :: forall e. DomElement -> String -> EffDom e Unit
setValue = runFn2 setValueImpl

foreign import onInputImpl :: forall e a. Fn2 DomElement (EffDom e Unit) (EffDom e Unit)

onInput :: forall e a. DomElement -> EffDom e Unit -> EffDom e Unit
onInput = runFn2 onInputImpl

foreign import onClickImpl :: forall e a. Fn2 DomElement (EffDom e Unit) (EffDom e Unit)

onClick :: forall e a. DomElement -> EffDom e Unit -> EffDom e Unit
onClick = runFn2 onClickImpl

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
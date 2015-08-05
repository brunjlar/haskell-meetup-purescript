module Aff where

import Prelude
import Control.Monad.Cont.Trans
import Control.Monad.Eff
import Data.Maybe.Unsafe

import Dom

(>>) :: forall m a b. (Bind m) => m a -> m b -> m b
(>>) ma mb = ma >>= (\_ -> mb)

type Aff e = ContT Unit (Eff e)

runAff :: forall e a. Aff e a -> Eff e Unit
runAff x = runContT x (\_ -> return unit)

message :: forall e. String -> Aff (dom :: DOM | e) Unit
message s = ContT $ \cont -> do
    div <- createElement "div"
    p <- createElement "p"
    t <- createTextNode s
    b <- button "Okay" (return unit)
    onClick b ((removeClick b) >> body >>= (flip removeChild div) >> (cont unit))
    p `appendChild` t
    div `appendChild` p
    div `appendChild` b
    body >>= flip appendChild div
    
yesNo :: forall e. String -> Aff (dom :: DOM | e) Boolean
yesNo s = ContT $ \cont -> do
    div <- createElement "div"
    p <- createElement "p"
    t <- createTextNode s
    yes <- button "Yes" (return unit)
    no <- button "No" (return unit)
    onClick yes ((removeClick no)  >> (removeClick yes) >> body >>= (flip removeChild div) >> (cont true))
    onClick no  ((removeClick yes) >> (removeClick no)  >> body >>= (flip removeChild div) >> (cont false))
    p `appendChild` t
    div `appendChild` p
    div `appendChild` yes
    div `appendChild` no
    body >>= flip appendChild div
    
input :: forall e. String -> Aff (dom :: DOM | e) String
input s = ContT $ \cont -> do
    div <- createElement "div"
    p <- createElement "p"
    t <- createTextNode s
    i <- createElement "input"
    setAttribute i "type" "text"
    b <- button "Okay" (return unit)    
    onClick b ((removeClick b) >> body >>= (flip removeChild div) >> (getValue i) >>= (fromJust >>> cont))
    p `appendChild` t
    div `appendChild` p
    div `appendChild` i
    div `appendChild` b
    body >>= flip appendChild div
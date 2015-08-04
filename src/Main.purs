module Main where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Class
import Control.Monad.Eff.Console

import Aff
import Dom
        
main :: forall eff. Eff (dom :: DOM, console :: CONSOLE | eff) Unit
main = do
    b <- button "Click me!" (log "clicked!")
    body >>= flip appendChild b
    runAff do
        message "Program started!"
        answer <- yesNo "Are you tired?"
        liftEff $ log $ "You answered with " ++ (if answer then "yes" else "no") ++ "!"
        name <- input "What is your name?"
        liftEff $ log $ "Hello, " ++ name ++ "!"
    
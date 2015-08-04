module Main where

import Control.Monad.Eff
import Control.Monad.Eff.Console
import Data.Maybe
import Dom
import Prelude

type HasAge r = { age :: Int | r }

birthday :: forall r. HasAge r -> HasAge r
birthday p = p { age = p.age + 1 }

type Person = { name :: String, age :: Int}

showPerson :: Person -> String
showPerson p = p.name ++ "(" ++ show p.age ++ ")"

lars :: Person
lars = { name: "Lars", age: 43 }

getPerson :: forall eff. Eff (dom :: DOM, console :: CONSOLE | eff) (Maybe Person)
getPerson = do
    mn <- getValueById "name"
    ma <- getIntValueById "age"
    return do
        n <- mn
        a <- ma
        return { name: n, age: a }

inputHandler :: forall eff. Eff (dom :: DOM, console :: CONSOLE | eff) Unit
inputHandler = do
    mp <- getPerson
    log case mp of
        Just p -> showPerson p
        Nothing -> "NO VALID PERSON"
        
clickHandler :: forall eff. Eff (dom :: DOM, console :: CONSOLE | eff) Unit
clickHandler = do
    mp <- getPerson
    case mp of
        Just p -> setValueById "age" $ show $ p.age + 1
        Nothing  -> return unit
        
main :: forall eff. Eff (dom :: DOM, console :: CONSOLE | eff) Unit
main = do
    log $ showPerson $ birthday lars
    inputHandler
    onInput "name" inputHandler
    onInput "age" inputHandler
    onClick "birthday" clickHandler
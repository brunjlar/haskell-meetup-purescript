module Main where

import Control.Monad.Eff.Console
import Prelude

type HasAge r = { age :: Int | r }

birthday :: forall r. HasAge r -> HasAge r
birthday p = p { age = p.age + 1 }

type Person = { name :: String, age :: Int}

showPerson :: Person -> String
showPerson p = p.name ++ "(" ++ show p.age ++ ")"

lars :: Person
lars = { name : "Lars", age : 43 }

main = do
    log $ showPerson $ birthday lars

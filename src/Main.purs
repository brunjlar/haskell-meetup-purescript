module Main where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Class
import Control.Monad.Eff.Console
import Control.Monad.State.Class
import Control.Monad.State.Trans
import Control.Monad.Trans

import Aff
import Dom
import Tree

type M = StateT Cursor (Aff (dom :: DOM, console :: CONSOLE))
      
ask :: M Animal
ask = do
    c@(Cursor t _) <- get
    case t of
        Leaf a   -> return a
        Node q _ -> do 
            yn <- lift $ yesNo q
            put $ if yn then yes c else no c
            ask
            
check :: Animal -> M Unit
check a = do
    yn <- lift $ yesNo $ "Did you think of '" ++ a ++ "'?"
    c <- get
    flip (>>=) put $ (cursor <<< tree) <$> if yn
        then return c
        else do
            a' <- lift $ input "What animal DID you think of?"
            q <- lift $ input $ "What is a question that distinguishes between '" ++ a ++ "' and '" ++ a' ++ "'?"
            yn' <- lift $ yesNo $ "What is the answer for '" ++ a ++ "'?"
            let t = Node q (if yn' then {yes: Leaf a, no: Leaf a'} else {yes: Leaf a', no: Leaf a})
            return $ edit c t
            
round :: M Unit
round = do
    c <- get
    liftEff $ log $ show $ tree c
    lift $ message "Please think of an animal!"
    ask >>= check
        
pangolin :: forall a. M a
pangolin = do
    round
    pangolin
        
main :: Eff (dom :: DOM, console :: CONSOLE) Unit
main = runAff $ evalStateT pangolin (cursor $ Leaf "lion")
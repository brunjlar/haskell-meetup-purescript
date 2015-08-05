module Tree where

import Prelude

type Question = String

type Animal = String

data Tree = Node Question { yes :: Tree, no :: Tree } | Leaf Animal

instance showTree :: Show Tree where
    show (Leaf a) = a
    show (Node q xs) = "<" ++ q ++ " | " ++ show xs.yes ++ " | " ++ show xs.no ++ ">"
    
data Cursor = Cursor Tree (Tree -> Tree)

cursor :: Tree -> Cursor
cursor t = Cursor t id

tree :: Cursor -> Tree
tree (Cursor t f) = f t

edit :: Cursor -> Tree -> Cursor
edit (Cursor _ f) t = Cursor t f

yes :: Cursor -> Cursor
yes c@(Cursor (Leaf _) _) = c
yes (Cursor (Node q xs) f) = Cursor xs.yes (\t -> f $ Node q xs { yes = t })

no :: Cursor -> Cursor
no c@(Cursor (Leaf _) _) = c
no (Cursor (Node q xs) f) = Cursor xs.no (\t -> f $ Node q xs { no = t })
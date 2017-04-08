module Model.Tree exposing (..)

type Tree a = TreeNode a (List (Tree a))

newTree : a -> Tree a
newTree elem = TreeNode elem []

extractElem : Tree a -> a
extractElem (TreeNode elem _) = elem

appendChild: Tree a -> a -> Tree a
appendChild parent child =
    let
        (TreeNode elem existingChildren) = parent
    in
        (TreeNode elem ((TreeNode child []):: existingChildren))

foldOverTree : (a -> b) -> (b -> b -> b) -> Tree a -> b
foldOverTree valueMapper combiner (TreeNode a children) =
    List.foldr combiner (valueMapper a) (List.map (foldOverTree valueMapper combiner) children)

findAllElemsRecursive : Tree a -> List a
findAllElemsRecursive = foldOverTree List.singleton (++)

findAllImmediateChildren : Tree a -> List a
findAllImmediateChildren (TreeNode _ children) = List.map extractElem children


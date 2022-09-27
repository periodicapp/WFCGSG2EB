-- data type for binary tree
data BinTree a = Empty | Branch a (BinTree a) (BinTree a)
  deriving (Show)

-- construct takes a list of Int and returns the BinTree representation of that
-- list by inserting each element one at a time
construct :: [Int] -> BinTree Int
construct (x:xs) = 
  let 
    l = filter (<x) xs
    r = filter (>x) xs
  in
    case (l,r) of
      ([],[]) -> Branch x Empty Empty
      ([],_) -> Branch x Empty (construct r)
      (_,[]) -> Branch x (construct l) Empty
      (_,_) -> Branch x (construct l) (construct r)

construct [] = Empty

-- treeNode takes a BinTree and returns the node value if it exists, 0
-- otherwise
treeNode :: BinTree Int -> Int
treeNode t =
  case t of
    (Branch x _ _) -> x
    Empty -> 0

-- treeChildren takes a BinTree and returns a representation of the children -
-- which is an empty list for an empty tree, the head of the left child, plus a
-- 0, plus the presentation of its children in the case of a tree with a left
-- branch but without a right branch, a 0 followed by the array representation
-- of the right branch in the case where the tree has a right branch but no
-- left branch, and otherwise the heads of the left and right branches follows
-- by the children of the left followed by the children of the right
treeChildren :: BinTree Int -> [Int]
treeChildren t =
  case t of
    (Branch x Empty Empty) -> [] 
    (Branch x y Empty) -> [treeNode y,0] ++ treeChildren y
    (Branch x Empty y) -> [0] ++ toArray y
    (Branch x y z) -> [treeNode y, treeNode z] ++ treeChildren y ++ treeChildren z

-- toArray takes a BinTree and creates an array representation of it.
-- Node-only branches are singleton lists of the node value.  Trees with an
-- empty left branch are the node value plus a 0 to represent the empty branch
-- and then a recusive call to toArray for the right branch.  With an empty
-- right branch, the representation if the node value plus the node head of the
-- left branch plus a 0 to mark the empty right branch, and then the
-- representation of the children of the left branch.  And the general case -
-- when both branches have content - is the node head, plus the node heads of
-- the left and right trees followed by the children of the left tree followed
-- by the children of the right tree.  The base case (an empty tree) is [0].
toArray :: BinTree Int -> [Int]
toArray t = 
  case t of
    (Branch x Empty Empty) -> [x]
    (Branch x Empty y) -> [x,0] ++ toArray y
    (Branch x y Empty) -> [x, treeNode y, 0] ++ treeChildren y
    (Branch x y z) -> [x, treeNode y, treeNode z] ++ treeChildren y ++ treeChildren z
    Empty -> [0]

-- allCombine is a helper function for allSorts that takes two lists of lists
-- and combines then into one list of lists by adjoining every list in the
-- second collection to every item in the first
allCombine :: [[Int]] -> [[Int]] -> [[Int]]
allCombine l r = 
  case (l,r) of
    ([],_) -> r
    (_,[]) -> l
    otherwise -> [li++ri | li <- l, ri <- r]

-- allSorts is a helper function for genInsertOrders.  It takes a(n implicitly
-- sorted) list of numbers and returns a list of all the orderings of those
-- numbers that would result in a set of unique trees if those numbers were
-- inserted, in the order they're given, into a binary search/sort tree.  It
-- does this by iterating over all the items in the list and prepending that
-- item onto the result of recursively calling allSorts on (a) a list of all
-- the remaining elements that are less than the current element and (b) a list
-- of all the elements in the remaining list that are greater than the current
-- element and then (c) concatenating all the lists from the first set onto
-- those of the second set in all possible ways to generate all the relevant
-- "sortings" for making unique trees.
allSorts :: [Int] -> [[Int]]
allSorts ls =
  case ls of 
    [] -> []
    [x] -> [[x]]
    otherwise -> [zs | i <- ls, zs <- map (i:) $ allCombine (allSorts (filter (<i) ls)) (allSorts (filter (>i) ls))]

-- genInsertOrders is the driver function.  It takes a number which represents
-- the target number of nodes in the tree(s), generates a list from 1 up to the
-- number of nodes, and returns a list of lists of Ints which represent all the
-- insertion orders for these numbers which would result in unique trees of the
-- requested number of nodes
genInsertOrders :: Int -> [[Int]]
genInsertOrders n = allSorts [1..n]

-- printResults is a printer function that loops over all the returned tree
-- representations and prints them
printResults :: [[Int]] -> IO [()]
printResults = mapM (print . toArray . construct) 

main = printResults $ genInsertOrders 3
--main = mapM (print . toArray . construct) $ allSorts [1,2,3,4,5,6,7,8]

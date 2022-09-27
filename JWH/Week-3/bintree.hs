
data BinTree a = Empty | Branch a (BinTree a) (BinTree a)
  deriving (Show)

construct' :: Int -> [Int] -> [Int] -> BinTree Int
construct' x l r
  | l == [] && r == [] = Branch x Empty Empty 
  | l == [] = Branch x Empty (construct r)
  | r == [] = Branch x (construct l) Empty
  | otherwise = Branch x (construct l) (construct r)

construct :: [Int] -> BinTree Int
construct (x:xs) = 
  let 
    left = filter (<x) xs
    right = filter (>x) xs
  in
    construct' x left right 

treeNode :: BinTree Int -> Int
treeNode t =
  case t of
    (Branch x _ _) -> x
    Empty -> 0

children :: BinTree Int -> [Int]
children t =
  case t of
    (Branch x Empty Empty) -> [] 
    (Branch x y Empty) -> [treeNode y,0] ++ children y
    (Branch x Empty y) -> [0] ++ toArray y
    (Branch x y z) -> [treeNode y, treeNode z] ++ children y ++ children z

toArray :: BinTree Int -> [Int]
toArray t = 
  case t of
    (Branch x Empty Empty) -> [x]
    (Branch x Empty y) -> [x,0] ++ toArray y
    (Branch x y Empty) -> [x] ++ [treeNode y,0] ++ children y
    (Branch x y z) -> [x] ++ [treeNode y, treeNode z] ++ children y ++ children z
    Empty -> [0]

main = mapM (print . toArray . construct) [
         [1,2,3]
       , [1,3,2]
       , [2,1,3]
       , [3,1,2]
       , [3,2,1]
       , [1,2,3,4,5]
       , [1,3,2,4,5]
       , [1,3,2,5,4]
       , [1,4,2,3,5]
       , [1,4,3,2,5]
       , [1,5,2,3,4]
       , [1,5,2,4,3]
       , [1,5,3,2,4]
       ]
--main = print $ toArray $ construct [3,4,1,5,2]
--main = print $ toArray $ construct [5,4,1,3,2]
--main = print $ toArray $ construct [1,2,3,4,5]
--main = print $ toArray $ construct [2,1,3,4,5]
--main = print $ toArray $ construct [3,1,2,4,5]
--main = print $ toArray $ construct [4,1,2,3,5]
--main = print $ toArray $ construct [5,1,2,3,4]

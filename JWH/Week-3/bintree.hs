-- data type for binary tree
data BinTree a = Empty | Branch a (BinTree a) (BinTree a)
  deriving (Show)

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

allCombine :: [[Int]] -> [[Int]] -> [[Int]]
allCombine l r = 
  case (l,r) of
    ([],_) -> r
    (_,[]) -> l
    otherwise -> [li++ri | li <- l, ri <- r]

allSorts :: [Int] -> [[Int]]
allSorts ls =
  case ls of 
    [] -> []
    [x] -> [[x]]
    otherwise -> [zs | i <- ls, zs <- map (i:) $ allCombine (allSorts (filter (<i) ls)) (allSorts (filter (>i) ls))]

main = mapM (print . toArray . construct) $ allSorts [1,2,3]
--main = mapM (print . toArray . construct) $ allSorts [1,2,3,4,5,6,7,8]

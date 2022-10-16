--del - removes (the first instance of) an item from a list
del :: (Eq a) => a -> [a] -> [a]
del _ [] = []
del x (l:ls)
  | x == l = ls
  | otherwise = l : del x ls

--allHeads - takes a list (of potential heads) and another list (which whould
--be the tail) and, for each item in the first list, prepends it to the second
--list, taking care that the item being prepended has been removed (at least,
--that the first instance of it) from the second list before prepending.
allHeads :: [(Int,Int)] -> [(Int,Int)] -> [[(Int,Int)]]
allHeads [] _ = []
allHeads (a:as) b = (a : (del a b)) : allHeads as b

--arrangePairs - the main function.  Flesh this out.
arrangePairs :: [(Int,Int)] -> [[(Int,Int)]]
arrangePairs [] = []
arrangePairs ((s,e):ps) = 
  let
    tails = allHeads (filter ((==e) . fst) ps) ps
  in
    map ((s,e):) tails

displayPairs :: Maybe [(Int,Int)] -> IO ()
displayPairs (Just ps) = print ps
displayPairs Nothing = print $ ([]::[(Int,Int)])

(<||>) :: (Monoid a, Eq a) => a -> a -> a
x <||> y
  | x == mempty = y
  | otherwise = x

--main = print $ validTails (11,9) [(4,5),(11,9),(9,4)]
--main = print $ Nothing <||> Just [(1,2)]
--main = displayPairs $ arrangePairs [(11,9),(4,5),(9,4)]
main = print $ arrangePairs [(11,9),(9,1),(4,5),(9,4)]


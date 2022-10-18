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
allHeads :: [(Int,Int)] -> [(Int,Int)] -> [((Int,Int),[(Int,Int)])]
allHeads [] _ = []
allHeads (a:as) b = (a , del a b) : allHeads as b

--mapp is needed to propagate the failure in cases where no path can be found 
mapp :: (Int,Int) -> Maybe [(Int,Int)] -> Maybe [(Int,Int)]
mapp (x,y) (Just zs) = Just ((x,y) : zs)
mapp (x,y) Nothing = Nothing

--arrangePairs takes a candidate starting pair and a list of remaining pairs
--and builds all possible continuation lists.  If none are possible, it returns
--Nothing.  Otherwise, it returns (Just solution) - where "solution" is a list
--of (Int,Int) pairs.  It works by first building a list - called conts - of
--all possible pairs in the existing list that can continue from the current
--pair (that is, that have a left member that is the same as the right member
--of the current pair).  Then it calls allHeads to build a list of
--((Int,Int),[(int,Int)]) based on this (each left side of the pair is a member
--of conts, and the left side is the remaining list with the item on the left
--side removed), for each of which it recursively calls arrangePairs to try to
--build to the end of the list.  It prepends the current candidate to the first
--of whichever of these succeeds (if they all fail, the result is Nothing).
--There are two situations where there are no feasible continuations - when
--we've reached the end of the list, in which case the current candidate is the
--end of the chain and it's a success - and when there are no viable candidates
--in the current list, in which case it fails with Nothing.
arrangePairs :: ((Int,Int),[(Int,Int)]) -> Maybe [(Int,Int)]
arrangePairs ((x,y),[]) = Just [(x,y)]
arrangePairs ((x,y),ls) =
  let
    conts = filter ((==y) . fst) ls
  in
    if (length conts) == 0 then Nothing else (x,y) `mapp` (foldl1 (<||>) $ map arrangePairs $ allHeads conts ls)
    
--displayPairs unwraps the Maybe monoid from the result and prints it
displayPairs :: Maybe [(Int,Int)] -> IO ()
displayPairs (Just ps) = print ps
displayPairs Nothing = print $ ([]::[(Int,Int)])

(<||>) :: (Monoid a, Eq a) => a -> a -> a
x <||> y
  | x == mempty = y
  | otherwise = x

--arrangeList - the entry function.  Takes a list and sets up the initial call
--to arrangePairs.  Returns an arranged list if there is a possible
--arrangement, otherwise returns failure.
arrangeList :: [(Int,Int)] -> Maybe [(Int,Int)]
arrangeList ls = foldl1 (<||>) $ map arrangePairs $ allHeads ls ls

--main = print $ validTails (11,9) [(4,5),(11,9),(9,4)]
--main = print $ Nothing <||> Just [(1,2)]
--main = displayPairs $ arrangePairs ((11,9),[(4,5),(9,4)])
--main = displayPairs $ arrangePairs ((11,9),[(5,1),(4,5),(9,4)])
--main = displayPairs $ foldl1 (<||>) $ map arrangePairs $ allHeads [(11,9),(5,1),(4,5),(9,4)] [(11,9),(5,1),(4,5),(9,4)]
main = displayPairs $ arrangeList [(11,9),(5,1),(4,5),(9,4)]

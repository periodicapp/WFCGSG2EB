--Given a list of indices and a list of source items, return the sublist of the
--source items composed of only those items in order
getItemsAtIndices :: [Int] -> [a] -> [a]
getItemsAtIndices idxs ls
  | (length idxs) > (length ls) = []
  | otherwise = [ls !! i | i <- idxs]

--Determine, for a list of indices, whether it is at its relative "final" value
genIndList :: [Int] -> Int -> Int -> [Bool]
genIndList idxs r n = [x == i + n - r | (i,x) <- (zip [0..] idxs) ]

--Given a list of indices which is known to be incomplete (not every index is
--at its "final" value) determine the "innermost" index which is nonfinal
getBreakIndex :: [Int] -> Int -> Int -> Int 
getBreakIndex idxs r n = [i | (i,b) <- reverse $ zip [0..] (genIndList idxs r n), b == False] !! 0

--Check whether we are at the end of item generation - which we are if ALL
--indices are at their "final" value
checkTermIndices :: [Int] -> Int -> Int -> Bool
checkTermIndices idxs r n  = all (== True) [x == i + n - r | (i, x) <- reverse (zip [0..] idxs) ]

--Helper function for runIncFromIndex
incFromIndex :: Int -> Int -> Int -> [Int] -> [Int]
incFromIndex i c nxt (id:idxs)
  | c < i = id : incFromIndex i (c+1) id idxs
  | c == i = (id+1) : incFromIndex i (c+1) (id+1) idxs
  | c > i = (nxt+1) : incFromIndex i (c+1) (nxt+1) idxs

--Helper function for runIncFromIndex
incFromIndex i c nxt _ = []

-- Given an index and a current list of indices, return the next list of
-- indices in the ordering
runIncFromIndex :: Int -> [Int] -> [Int]
runIncFromIndex i idxs = incFromIndex i 0 0 idxs
  
--Helper function for getIndexLists
getIndexLists' :: Int -> Int -> [Int] -> [[Int]]
getIndexLists' n r idxs
  | checkTermIndices idxs r n = [idxs]
  | otherwise = idxs : getIndexLists' n r (runIncFromIndex (getBreakIndex idxs r n) idxs)

--Generate the list of indexes for each combination
getIndexLists :: Int -> Int -> [[Int]]
getIndexLists n r = 
  let 
    initial = [0..(r-1)]
  in
    getIndexLists' n r initial

--Get all subset combinations of length n of a given list
getCombinations :: Int -> [Int] -> [[Int]]
getCombinations n items =
  let
    indices = getIndexLists (length items) n
  in
    [getItemsAtIndices idxs items | idxs <- indices]

--The driver function.  Get all cominations of length 4 of an input list where
--the elements sum to the given target
sum4 :: [Int] -> Int -> [[Int]]
sum4 input target = [x | x <- getCombinations 4 input, sum x == target]

--main = print $ sum4 [1,0,-1,0,-2,2] 0
main = mapM_ (\x -> print x) (sum4 [-99..99] 100)
--main = print $ getIndexLists 6 4

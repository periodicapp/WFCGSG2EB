import System.Random
import Data.Sort

--getList - generate a list of length n of random integers that are between 0
--and l
getList :: Int -> Int -> StdGen -> [Int]
getList n l g = take n (randomRs (0::Int, l) g)

--diffs takes a list of Int and returns the list that is the differences
--between all of the items.  For example, for the list [3,3,5,0] it would
--return [0,2,-5].
diffs :: [Int] -> [Int]
diffs x = zipWith (flip (-)) x (tail x)

--maxsum takes a list of Int and returns the value of the subsequence with the
--highest sum.  The first two arguments should be 0 0 on the initial call:
--they're for keeping track of the value of the current sum and the
--current-highest observed sum
maxsum :: Int -> Int -> [Int] -> Int
maxsum _ m [] = m
maxsum c m (l:ls) =
  let
    curr = if c + l > l then c + l else l
  in
    if m > curr then maxsum curr m ls else maxsum curr curr ls

--mxsumi does what maxsum does but also keeps track of the left and right
--positions of any sequence that was, at any time, under consideration for
--"maximum (in the sense of having the highest sum) subsequence"
mxsumi :: Int -> Int -> Int -> Int -> Int -> [(Int,Int,Int)] -> [Int] -> [(Int,Int,Int)]
mxsumi _ _ _ _ _ acc [] = acc
mxsumi c m l r i acc (x:xs) =
  let
    curr = if c + x > x then c + x else x
    l1 = if x > c + x then i else l
  in
    if m > curr then (mxsumi curr m l1 i (i+1) acc xs) else (mxsumi curr curr l1 r (i+1) ((l1,(i+1),curr):acc) xs)

sumwith :: [Int] -> [Int] -> [Int]
sumwith ls xs = zipWith (+) ls (tail xs)

iterateCount :: ([Int] -> [Int]) -> [Int] -> Int -> [[Int]]
iterateCount f m i
  | i == 0 = [(f m)]
  | otherwise = (f m) : iterateCount f (f m) (i-1)

--overlaps takes two triples representing spans in an array along with their
--sums.  This function doesn't need the sum and so ignores it.  Returns true if
--the spans overlap, false otherwise.
overlaps :: (Int,Int,Int) -> (Int,Int,Int) -> Bool
overlaps (a,b,_) (x,y,_)
  | y > b = x < b
  | b > y = a < y
  | y == b = True

--eliminateOverlaps takes a list of triples representing spans in an array
--along with their sums.  As it happens, the leftmost element in this list will
--be the one with the largest sum.  This function retains that one and then
--removes any that overlap with it from the remainder of the list.
eliminateOverlaps :: [(Int,Int,Int)] -> [(Int,Int,Int)]
eliminateOverlaps [] = []
eliminateOverlaps (l:ls) = l : (filter (not . (overlaps l)) ls)

thrd :: (Int,Int,Int) -> Int
thrd (_,_,e) = e

--sortBySum takes a list of triples, where the last element of the triple
--represents the sum of a span of an array of Int (and the edges of the span
--are specified by the first two elements in the triple), and returns the list
--in descending order by sum
sortBySum :: [(Int,Int,Int)] -> [(Int,Int,Int)]
sortBySum = reverse . (sortOn thrd)

--NEXT
-- 1. Define splitter (should decline to split when len is less than 4)
--
-- 2. Define bestSpans  - which picks the items from a list of triples that sum
-- the most - for lists of at most 4
--
-- 3. Solution is found by picking the best two out of the list that is the
-- concatenation of: the original non-overlapping solution list, the call to
-- the same function on the remainder of the list,  the result of splitting the
-- first list (assuming it is splittable), and the result of calling the
-- function on the beg. of the list up to the end of the first half of the
-- split


--buildmatrix - left over from an earlier attempt, but we might want to use it.
--Builds a dynamic programming type matrix of differences - first between each
--element, then between every other element, etc.  Does not attempt to generate
--this sum for the length spanning the array, however: it's enough to stop
--halway through, since any spanning link will be the sum of two halves
--generated on either side of the midpoint anyway
buildmatrix :: [Int] -> [[Int]]
buildmatrix ls =
  let
    seed = diffs ls
  in
    iterateCount (sumwith seed) seed ((length ls) `div` 2)

main = do
  g <- getStdGen
  --let stocks = getList 10 10 g
  let stocks = getList 10 10 g
  let dfs = diffs stocks
  print $ stocks
  print $ dfs
  --let mat = buildmatrix stocks
  --print $ mat
  print $ maxsum 0 0 dfs
  print $ mxsumi 0 0 0 0 0 [] dfs 
  print $ sortBySum $ eliminateOverlaps $ mxsumi 0 0 0 0 0 [] dfs 
  --print $ maxsum 0 0 (diffs [5,8,4,4,8,9,8])

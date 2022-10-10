import System.Random

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

--overlaps takes two tuples, the second element of which is a position in an
--array and the first is a width.  These coordinates overlap if the left end of
--the one that's positioned further right is to the left of the other's
--position
overlaps :: (Int,Int) -> (Int,Int) -> Bool
overlaps (a,b) (x,y)
  | y > b = (y - x) < b
  | b > y = (b - a) < y

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
  --print $ maxsum 0 0 (diffs [5,8,4,4,8,9,8])

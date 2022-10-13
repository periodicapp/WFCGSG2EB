import System.Random

getList :: Int -> Int -> StdGen -> [Int]
getList n l g = take n (randomRs (0::Int, l) g)

maxProfitsRight :: Int -> Int -> [Int] -> [Int]
maxProfitsRight _ mpf [] = [] 
maxProfitsRight lw mpf (l:ls) = 
  let
    low = min l lw
    mp = max (l - lw) mpf
  in
    mp : (maxProfitsRight low mp ls)

mp :: Int -> Int -> Int -> [(Int,Int)] -> [Int] -> Int
mp  _ _ fp [] _ = fp
mp h mpp fp ((i,l):ll) rr = 
  let
    hg = max h l
    maxprf = max (h - l) mpp
    finalprofit = max fp (maxprf + rr !! i)
  in
    mp hg maxprf finalprofit ll rr

maxProfit :: [Int] -> [Int] -> Int
maxProfit ll rr = mp 0 0 0 (reverse $ zip [0..] ll) rr

--main = print $ maxProfitsRight 5 0 [5,9,1,2,7,3,8,3,6,5]
main = do 
  g <- getStdGen
  let stocks = getList 10 10 g
  print $ stocks
  print $ maxProfit stocks $ maxProfitsRight (head stocks) 0 stocks



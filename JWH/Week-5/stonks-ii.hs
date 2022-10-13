import System.Random

getList :: Int -> Int -> StdGen -> [Int]
getList n l g = take n (randomRs (0::Int, l) g)

maxProfitsRight :: Int -> Int -> Int -> Int -> [(Int,Int)] -> [(Int,Int,Int)]
maxProfitsRight _ _ _ _ [] = [] 
maxProfitsRight lw mpf mn h ((j,l):ls) = 
  let
    low = min l lw
    minindex = if l < lw then j else mn
    mp = max (l - lw) mpf
    maxindex = if l - lw > mpf then j else h
  in
    (mn,maxindex,mp) : (maxProfitsRight low mp minindex maxindex ls)

thrd :: (Int,Int,Int) -> Int
thrd (_,_,e) = e

mp :: Int -> Int -> Int -> ((Int,Int,Int),(Int,Int,Int)) -> [(Int,Int)] -> [(Int,Int,Int)] -> (Int,((Int,Int,Int),(Int,Int,Int)))
mp  _ _ fp fl [] _ = (fp,fl)
mp h mpp fp ((x1,x2,x3),(y1,y2,y3)) ((i,l):ll) rr = 
  let
    hg = max h l
    yy2 = if h > l then y2 else i
    maxprf = max (h - l) mpp
    yy1 = if h - l > mpp then i else y1
    finalprofit = max fp (maxprf + (thrd $ rr !! i))
    lhs = if fp > (maxprf + (thrd $ rr !! i)) then (x1,x2,x3) else (rr !! i) 
  in
    mp hg maxprf finalprofit (lhs,(yy1,yy2,maxprf)) ll rr

maxProfit :: [Int] -> [(Int,Int,Int)] -> (Int,((Int,Int,Int),(Int,Int,Int)))
maxProfit ll rr = mp 0 0 0 ((0,0,0),(0,0,0)) (reverse $ zip [0..] ll) rr

--main = print $ maxProfitsRight 5 0 [5,9,1,2,7,3,8,3,6,5]
main = do 
  g <- getStdGen
  let stocks = getList 10 10 g
  print $ stocks
  print $ maxProfitsRight (head stocks) 0 0 0 (zip [0..] stocks)
  print $ maxProfit stocks $ maxProfitsRight (head stocks) 0 0 0 (zip [0..] stocks)



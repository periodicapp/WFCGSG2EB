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

thrd :: (a,a,a) -> a
thrd (_,_,e) = e

frst :: (a,a,a) -> a
frst (e,_,_) = e

scnd :: (a,a,a) -> a
scnd (_,e,_) = e

mp :: Int -> Int -> Int -> ((Int,Int,Int),(Int,Int,Int),(Int,Int,Int)) -> [(Int,Int)] -> [(Int,Int,Int)] -> (Int,((Int,Int,Int),(Int,Int,Int)))
mp  _ _ fp fl [] _ = (fp,(frst fl, scnd fl))
mp h mpp fp ((x1,x2,x3),(y1,y2,y3),(z1,z2,z3)) ((i,l):ll) rr = 
  let
    hg = max h l
    yy2 = if l > h then i else z2
    maxprf = max (h - l) mpp
    yy1 = if h - l > mpp then i else z1
    finalprofit = max fp (maxprf + (thrd $ rr !! i))
    lhs = if fp > (maxprf + (thrd $ rr !! i)) then (x1,x2,x3) else (rr !! i) 
    rhs = if fp > (maxprf + (thrd $ rr !! i)) then (y1,y2,y3) else (yy1,yy2,maxprf)
  in
    mp hg maxprf finalprofit (lhs,rhs,(yy1,yy2,0)) ll rr

maxProfit :: [Int] -> [(Int,Int,Int)] -> (Int,((Int,Int,Int),(Int,Int,Int)))
maxProfit ll rr = mp (head . reverse $ ll) 0 0 ((0,0,0),(0,0,0),(0,((length ll)-1),0)) (reverse $ zip [0..] ll) rr

showdollar :: Int -> [Char]
showdollar i = " $" ++ (show i) ++ " "

printResult :: [Int] -> (Int,((Int,Int,Int),(Int,Int,Int))) -> [Char]
printResult stks (total,((x1,x2,x3),(y1,y2,y3))) = "Buy at " ++ (show x1) ++ (showdollar $ stks !! x1) ++ "then sell at " ++ (show x2) ++ (showdollar $ stks !! x2) ++ "to make" ++ (showdollar x3) ++ "\nthen buy at " ++ (show y1) ++ (showdollar $ stks !! y1) ++ " and sell at " ++ (show y2) ++ (showdollar $ stks !! y2) ++ "to make" ++ (showdollar $ y3) ++ "\nfor a total profit of:" ++ (showdollar total) ++ "\n\n"

--main = print $ maxProfitsRight 5 0 [5,9,1,2,7,3,8,3,6,5]
main = do 
  g <- getStdGen
  let stocks = getList 10 10 g
  print $ stocks
  let mp = maxProfit stocks $ maxProfitsRight (head stocks) 0 0 0 (zip [0..] stocks)
  print $ mp
  putStrLn ""
  putStrLn ""
  putStrLn $ printResult stocks mp

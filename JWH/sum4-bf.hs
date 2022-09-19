subsets :: [a] -> [[a]]
subsets [] = [[]]
subsets (x:xs) = [zs | ys <- subsets xs, zs <- [ys, (x:ys)]]

sublists :: Int -> [a] -> [[a]]
sublists n xs = [ys | ys <- subsets xs , length ys == n]

lists4 :: [Int] -> [[Int]]
lists4 = sublists 4

quads :: [Int] -> Int -> [[Int]]
quads xs targ = [ys | ys <- lists4 xs, sum ys == targ]

--main = print $ subsets [1,0,-1,0,-2,2]
--main = print $ sublists 4 [1,0,-1,0,-2,2]
main = print $ quads [1,0,-1,0,-2,2] 0
--main = print $ quads [1..27] 28

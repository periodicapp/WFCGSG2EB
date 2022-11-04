numCombos :: (Char, Int, Int) -> Char -> (Char, Int, Int)
numCombos (c, a, u) n =
  case (c, a, u) of
    ('0', a, u) -> (n, 0, a+u)
    ('1', a, u) -> (n, a+u, u)
    ('2', a, u) -> if n > '6' then (n, 0, a+u) else (n, a+u, u)
    otherwise -> (n, 0, a+u)

allCombos :: [Char] -> (Char, Int, Int)
allCombos = foldl numCombos ('0', 0, 1)

totalCombos :: [Char] -> Int
totalCombos [] = 0
totalCombos chs =
  let
    (c, a, u) = allCombos chs
  in
    a+u

--main = print $ totalCombos "1234126"
--main = print $ allCombos "1234126"
--1 2 3 4 1 2 6
--12 3 4 1 2 6
--1 23 4 1 2 6
--1 2 3 4 1 26
--12 3 4 1 26
--1 23 4 1 26
--1 2 3 4 12 6
--12 3 4 12 6
--1 23 4 12 6

--main = print $ totalCombos "2312612301"
--main = print $ allCombos "2312612301"
--2 3 1 2 6 1 2 3 01
--23 1 2 6 1 2 3 01
--2 3 1 26 1 2 3 01
--23 1 26 1 2 3 01
--2 3 12 6 1 2 3 01
--23 12 6 1 2 3 01
--2 3 1 2 6 1 23 01
--23 1 2 6 1 23 01
--2 3 1 26 1 23 01
--23 1 26 1 23 01
--2 3 12 6 1 23 01
--23 12 6 1 23 01
--2 3 1 2 6 12 3 01
--23 1 2 6 12 3 01
--2 3 1 26 12 3 01
--23 1 26 12 3 01
--2 3 12 6 12 3 01
--23 12 6 12 3 01

--main = print $ totalCombos "2201"
--main = print $ allCombos "2201"
--2 2 01
--2 20 1
--22 01

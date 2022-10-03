import Data.Char (digitToInt, intToDigit, chr)
import Data.List (intersperse)

--data PuzzleGrid = PuzzleGrid [[Int]]
--  deriving (Show)

initGrid :: Int -> [Int] -> [[Int]]
initGrid i = map (\x -> x:(take 10 (repeat i))) 

convertString :: [Char] -> [Int]
convertString = map digitToInt

gridNumbers :: [[Int]] -> [Int]
gridNumbers pg = map head pg

readPuzzle :: [Char] -> [[Int]] 
readPuzzle = (initGrid 1) . convertString

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n ls 
  | n > 0 = (take n ls) : (chunksOf n (drop n ls))
  | otherwise = []

addSeparators :: [[Char]] -> Int -> [[Char]]
addSeparators (l:ls) i 
  | ls == [] = [l, "+-----+-----+-----+\n"]
  | i `mod` 3 == 0 = "+-----+-----+-----+\n" : l : addSeparators ls (i+1)
  | otherwise = l : addSeparators ls (i+1)

renderGridLine :: [Int] -> [[Char]]
renderGridLine [] = [] 
renderGridLine ls = 
  let 
    sections = chunksOf 3 $ map intToDigit ls
    rows = chunksOf 3 $ sections
    rws = map (unwords . (\x -> ["|"] ++ x ++ ["|\n"]) . intersperse "|") rows
    separated = addSeparators rws 0 
  in
    separated

getItemsAtIndexes :: [a] -> [Int] -> [a]
getItemsAtIndexes pg [] = [] 
getItemsAtIndexes pg (i:idxs)
  | idxs == [] = [(pg !! i)]
  | otherwise = (pg !! i) : getItemsAtIndexes pg idxs

getIndexesForRow :: Int -> [Int]
getIndexesForRow i
  | i >= 0 && i < 81 && i `mod` 9 == 0 = [i..(i+8)]
  | otherwise = []


getRow :: [Int] -> Int -> [Int]
getRow grd i = getItemsAtIndexes grd (getIndexesForRow (i*9))
--getRow grd i = gtrw grd ((i*9)-1) 0 
--  where 
--    gtrw (r:rw) j c
--        | j < 0 || j > 81 = take 9 (r:rw)
--        | c > 81 || c < 0 = []
--        | c == j = take 9 $ rw
--        | otherwise = gtrw rw j (c+1)

getColumn :: [Int] -> Int -> [Int]
getColumn grd i = gtcl grd i 0
  where
    gtcl (c:cl) j k
      | j < 0 = gtcl grd 0 0
      | j > 80 = []
      | k > 80 || k < 0 = []
      | k == j = c : (gtcl cl (j+9) (k+1))
      | otherwise = gtcl cl j (k+1)

getGrid' :: [Int] -> (Int,Int) -> Int -> [Int]
getGrid' grd (rowoffset,columnoffset) limit
  | rowoffset < limit = (((take 3) . (drop columnoffset) . (getRow grd)) $ rowoffset) ++ (getGrid' grd ((rowoffset+1),columnoffset) limit)
--  | rowoffset < limit = [rowoffset+1]
  | otherwise = []
  
getGrid :: [Int] -> (Int,Int) -> [Int]
getGrid grd (row,column) =
  let
    rowoffset = (row `div` 3) * 3
    columnoffset = (column `div` 3) * 3
  in
    getGrid' grd (rowoffset,columnoffset) (rowoffset+3)
    
printGrid :: [[Int]] -> [Char]
printGrid = (foldr (++) "") . renderGridLine . gridNumbers

--main = print $ initGrid 0 $ take 81 (repeat 0)
main = 
  do
    input <- readFile "easy50.txt"
    --mapM (putStr . printGrid . readPuzzle) $ lines $ input
    --print $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    putStr $ printGrid $ readPuzzle $ ((!!0) . lines) input
    print $ ((flip getRow) 0) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getItemsAtIndexes) (getIndexesForRow 0)) $ readPuzzle $ ((!!0) . lines) input
    --print $ getIndexesForRow 0
    print $ ((flip getColumn) 7) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    print $ (flip getGrid (0,0)) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    print $ (flip getItemsAtIndexes [0,4,8,9]) $ readPuzzle $ ((!!0) . lines) input
    --print $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ readPuzzle $ ((!!0) . lines) input

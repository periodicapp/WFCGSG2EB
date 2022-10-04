import Data.Char (digitToInt, intToDigit, chr)
import Data.List (intersperse)

--data PuzzleGrid = PuzzleGrid [[Int]]
--  deriving (Show)

initGrid :: [Int] -> [[Int]]
initGrid = map (\x -> x:[1..9])

--removeItem takes an item and a list and removes the item from the list
removeItem :: Int -> [Int] -> [Int]
removeItem _ [] = []
removeItem x (y:ys) 
  | x == y = removeItem x ys
  | otherwise = y : removeItem x ys

--removePossibility takes an integer representing a value for a cell that is no
--longer possible for that cell and removes it from the list of possibilities.
--Because the representation used is a list of at most 10 - with the head
--representing the current value of the cell and the tail representing the
--remaining possible values (when the cell hasn't been solved) - we do this by
--concatenating the existing head onto the result of removing the value from
--the tail
removePossibility :: Int -> [Int] -> [Int]
removePossibility i (x:xs) = x : removeItem i xs

--clearSolvedCell takes list of Int representing a cell and, if the cell is
--"solved" (that is, it has a current value other than 0), removes the tail.
--This is because we use the head of the list to represent the current value
--and the tail to represent remaining possibilities.  Once the cell is solved,
--there is no need to keep track of remaining possibilities.  Cell
--representations of length 1 mean "solved."
clearSolvedCell :: [Int] -> [Int]
clearSolvedCell (x:xs) 
  | x /= 0 = [x]
  | otherwise = (x:xs)

--solveCell detects whether a cell has been solved and, if so, marks it as
--solved.  A cell is "solved" when it is an array of length 2: the first member
--being the current value of the cell and the second being the remaining
--possibilities.  (If there is only one possibility, the cell is solved.)  Mark
--the cell as solved by replacing the head value (i.e. the current value) with
--the second value (i.e. the remaining possibility).
solveCell :: [Int] -> [Int]
solveCell cl
  | (length cl) == 2 = [cl !! 1]
  | otherwise = cl

markSolvedCells :: [[Int]] -> [[Int]]
markSolvedCells = map solveCell

convertString :: [Char] -> [Int]
convertString = map digitToInt

--gridNumbers takes a "grid" - represented as a list of lists of Int (one list
--for each cell in the puzzle grid) and returns only the heads of each list.
--This is beacuse we're using the head of each member list to represent the
--value of the cell and the tail of each member list to hold the remaining
--possible values for the cell
gridNumbers :: [[Int]] -> [Int]
gridNumbers pg = map head pg

readPuzzle :: [Char] -> [[Int]] 
readPuzzle = (map clearSolvedCell) . initGrid  . convertString

isSolved :: [[Int]] -> Bool
isSolved pg = all (>0) $ gridNumbers pg

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

getIndexesForColumn :: Int -> [Int]
getIndexesForColumn i
  | i >= 0 && i < 9 = [i,(i+9)..80]
  | otherwise = []

getIndexesForGrid :: (Int,Int) -> [Int]
getIndexesForGrid (row,column) =
  let
    rowoffset = (row `div` 3) * 3
    columnoffset = (column `div` 3) * 3
  in
    [x | rw <- [0,1,2], x <- (take 3) . (drop columnoffset) . getIndexesForRow $ ((rw+rowoffset)*9)]

getIndexesForPeers :: (Int,Int) -> [Int]
getIndexesForPeers (row,column) = (getIndexesForRow (row*9)) ++ (getIndexesForColumn column) ++ (getIndexesForGrid (row,column))

getSolvedIndexes :: [[Int]] -> [(Int,Int)]
getSolvedIndexes pg = gsi 0 pg
  where
   gsi n [] = []
   gsi n (x:xs) = if (length x) == 1 then (head x,n) : gsi (n+1) xs else gsi (n+1) xs

removePossibilityFromCells :: [[Int]] -> [Int] -> Int -> Int -> [[Int]]
removePossibilityFromCells [] _ _ _ = []
removePossibilityFromCells (cell:cells) indexes current value
  | current `elem` indexes = (removePossibility value cell) : (removePossibilityFromCells cells indexes (current+1) value)
  | otherwise = cell : removePossibilityFromCells cells indexes (current+1) value
  

eliminateForSolvedCell :: (Int,Int) -> [[Int]] -> [[Int]]
eliminateForSolvedCell (value, index) pg  =
  let
    peerIndexes = getIndexesForPeers (getCoordinatesFromIndex index)
  in
    removePossibilityFromCells pg peerIndexes 0 value

eliminateForSolvedCells :: [[Int]] -> [[Int]]
eliminateForSolvedCells pg =
  let
    solvedindexes = getSolvedIndexes pg
  in
    foldr eliminateForSolvedCell pg solvedindexes

iterateUntilEqual :: (Eq a) => (a -> a) -> a -> a
iterateUntilEqual f i =
  let
    intermediate = f i
  in 
    if intermediate == i then intermediate else iterateUntilEqual f intermediate

eliminateForSolvedCellsStrategy :: [[Int]] -> [[Int]]
eliminateForSolvedCellsStrategy pg = iterateUntilEqual (eliminateForSolvedCells . markSolvedCells) pg

applyStrategy :: ([[Int]] -> [[Int]]) -> [[Int]] -> [[Int]]
applyStrategy strategy pg = strategy pg

getRow :: [Int] -> Int -> [Int]
getRow grd i = getItemsAtIndexes grd (getIndexesForRow (i*9))

getColumn :: [Int] -> Int -> [Int]
getColumn grd i = getItemsAtIndexes grd (getIndexesForColumn i)

getGrid :: [Int] -> (Int,Int) -> [Int]
getGrid grd (row,column) = getItemsAtIndexes grd (getIndexesForGrid (row,column))
    
getCoordinatesFromIndex :: Int -> (Int,Int)
getCoordinatesFromIndex i = (i `div` 9, i `mod` 9)

getIndexFromCoordinates :: (Int,Int) -> Int
getIndexFromCoordinates (i,j) = (i*9) + j

printGrid :: [[Int]] -> [Char]
printGrid = (foldr (++) "") . renderGridLine . gridNumbers

--main = print $ initGrid 0 $ take 81 (repeat 0)
main = 
  do
    input <- readFile "easy50.txt"
    let puzzle = readPuzzle $ ((!!0) . lines) input
    putStr $ printGrid puzzle
    putStrLn "\n\n"
    print $ puzzle
    putStrLn "\n\n"
    --print $ eliminateForSolvedCell puzzle (8,29)
    putStrLn "\n\n"
    --putStrLn $ printGrid $ iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 8
    --putStrLn $ printGrid $ iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 9
    --putStrLn $ printGrid $ iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 10
    --putStrLn $ printGrid $ iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 11
    --print $ (iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 11) == (iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 10)
    putStrLn $ printGrid $ eliminateForSolvedCellsStrategy puzzle
    --mapM (putStr . printGrid . readPuzzle) $ lines $ input
    --print $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --putStr $ printGrid $ readPuzzle $ ((!!0) . lines) input
    --print $ readPuzzle $ ((!!0) . lines) input
    --print $ getSolvedIndexes $ readPuzzle $ ((!!0) . lines) input
    --print $ getIndexesForPeers (2,6) 
    --print $ ((flip getRow) 0) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getItemsAtIndexes) (getIndexesForRow 0)) $ readPuzzle $ ((!!0) . lines) input
    --print $ (flip getGrid (0,0)) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ (flip getGrid (1,2)) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ (flip getGrid (5,8)) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ (flip getGrid (6,5)) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ (flip getItemsAtIndexes [0,4,8,9]) $ readPuzzle $ ((!!0) . lines) input
    --print $ getCoordinatesFromIndex 80
    --print $ getIndexFromCoordinates (8,8)
    --print $ getCoordinatesFromIndex 79
    --print $ getIndexFromCoordinates (8,7)
    --print $ getCoordinatesFromIndex 78
    --print $ getIndexFromCoordinates (8,6)
    --print $ getCoordinatesFromIndex 77
    --print $ getIndexFromCoordinates (8,5)
    --print $ getCoordinatesFromIndex 76
    --print $ getIndexFromCoordinates (8,4)
    --print $ getCoordinatesFromIndex 75
    --print $ getIndexFromCoordinates (8,3)
    --print $ getCoordinatesFromIndex 74
    --print $ getIndexFromCoordinates (8,2)
    --print $ getCoordinatesFromIndex 73
    --print $ getIndexFromCoordinates (8,1)
    --print $ getCoordinatesFromIndex 72
    --print $ getIndexFromCoordinates (8,0)
    --print $ getCoordinatesFromIndex 71
    --print $ getIndexFromCoordinates (7,8)
    --print $ getCoordinatesFromIndex 70
    --print $ getIndexFromCoordinates (7,7)
    --print $ getCoordinatesFromIndex 69
    --print $ getIndexFromCoordinates (7,6)
    --print $ getCoordinatesFromIndex 68
    --print $ getIndexFromCoordinates (7,5)
    --print $ getCoordinatesFromIndex 67
    --print $ getIndexFromCoordinates (7,4)
    --print $ getCoordinatesFromIndex 66
    --print $ getIndexFromCoordinates (7,3)
    --print $ getCoordinatesFromIndex 65
    --print $ getIndexFromCoordinates (7,2)
    --print $ getCoordinatesFromIndex 64
    --print $ getIndexFromCoordinates (7,1)
    --print $ getCoordinatesFromIndex 63
    --print $ getIndexFromCoordinates (7,0)
    --print $ getCoordinatesFromIndex 62
    --print $ getIndexFromCoordinates (6,8)
    --print $ getCoordinatesFromIndex 61
    --print $ getIndexFromCoordinates (6,7)
    --print $ getCoordinatesFromIndex 60
    --print $ getIndexFromCoordinates (6,6)
    --print $ isSolved $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getRow) 0) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getRow) 1) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getRow) 2) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getRow) 3) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getRow) 4) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getRow) 5) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getRow) 6) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getRow) 7) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getRow) 8) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getColumn) 0) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getColumn) 1) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getColumn) 2) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getColumn) 3) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getColumn) 4) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getColumn) 5) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getColumn) 6) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getColumn) 7) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ ((flip getColumn) 8) $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --print $ readPuzzle $ ((!!0) . lines) input

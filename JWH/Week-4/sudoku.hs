import Data.Char (digitToInt, intToDigit, chr)
import Data.List (intersperse)

--initGrid takes a list of integers representing an unsolved Sudoku puzzle (all
--solved cells should be 1-9, with 0 standing in for an unsolved cell) and
--converts it to a list of lists of integers, each of whcih is 10 items long.
--The head of the list is the value of the cell, and the remainder is the list
--of possible values for the cell.  Initially, all 9 values are possible for
--every cell, so function is just a matter of putting the head onto the list
--[1,2,3,4,5,6,7,8,9].  (clearSolvedCell will run over this next and remove the
--possibilities list from any cell that has a non-zero value - i.e. is "solved"
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
--Because the representation used is a list of at most 10 items - with the head
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

--solveCell detects whether a cell has been pre-solved (i.e. had all its
--possible values but one removed from the tail of the representation list)
--and, if so, marks it as solved.  A cell is "pre-solved" when it is an array
--of length 2: the first member being the current value of the cell and the
--second being the remaining possibilities.  (If there is only one possibility,
--the cell is solved.)  Mark the cell as solved by replacing the head value
--(i.e.  the current value) with the second value (i.e. the remaining
--possibility).
solveCell :: [Int] -> [Int]
solveCell cl
  | (length cl) == 2 = [cl !! 1]
  | otherwise = cl

--markSolvedCells - iterate over all cells, detect which ones are "pre-solved"
--and "solve" them
markSolvedCells :: [[Int]] -> [[Int]]
markSolvedCells = map solveCell

--convertString takes an input string representing a puzzle and converts it to
--a list of integers
convertString :: [Char] -> [Int]
convertString = map digitToInt

--gridNumbers takes a "grid" - represented as a list of lists of Int (one list
--for each cell in the puzzle grid) and returns only the heads of each list.
--This is beacuse we're using the head of each member list to represent the
--value of the cell and the tail of each member list to hold the remaining
--possible values for the cell
gridNumbers :: [[Int]] -> [Int]
gridNumbers pg = map head pg

--readPuzzle takes an input string representing a puzzle and returns the
--cleaned-up representation of the puzzle as a list of lists of integers
readPuzzle :: [Char] -> [[Int]] 
readPuzzle = (map clearSolvedCell) . initGrid  . convertString

--isComplete detects whether a puzzle is complete in the sense of having no
--0-valued cells - that is, every cell has a value between 1-9.
isComplete :: [[Int]] -> Bool
isComplete pg = all (>0) $ gridNumbers pg

--chunksOf takes an integer n and a list and splits the list into sections of
--length n.  e.g. chunksOf 2 [2,4,6,8] = [[2,4],[6,8]]
chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n ls 
  | n > 0 = (take n ls) : (chunksOf n (drop n ls))
  | otherwise = []


--addSeparators takes a list of strings - each representing a row in the string
--representation of a puzzle - and adds boundary rows at the top, at the
--bottom, and after each third row
addSeparators :: [[Char]] -> Int -> [[Char]]
addSeparators (l:ls) i 
  | ls == [] = [l, "+-----+-----+-----+\n"]
  | i `mod` 3 == 0 = "+-----+-----+-----+\n" : l : addSeparators ls (i+1)
  | otherwise = l : addSeparators ls (i+1)

--renderGridLine takes a list of 81 integers representing the values of the
--cells of a puzzle, converts them to characters, groups them into chunks of
--three (each representing the "box" section of a row) and then again into
--chunks of three (each representing a row - since a row is three groups of
--three cells), and then adds "|" characters around the subsections of each row
--to mark the begining and end and each section of the row.
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

--getItemsAtIndexes takes a list of things and a list of Ints representing
--indexes and returns a list populated with the item from the first list at the
--index indicated by each Int in the second list.
getItemsAtIndexes :: [a] -> [Int] -> [a]
getItemsAtIndexes pg [] = [] 
getItemsAtIndexes pg (i:idxs)
  | idxs == [] = [(pg !! i)]
  | otherwise = (pg !! i) : getItemsAtIndexes pg idxs

--getIndexesForRow given an index representing the start of a row (so, this
--must be an even multiple of 9 for a 9x9 matrix), return the indexes for the
--row
getIndexesForRow :: Int -> [Int]
getIndexesForRow i
  | i >= 0 && i < 81 && i `mod` 9 == 0 = [i..(i+8)]
  | otherwise = []

--getIndexesForColumn given an index representing the start of a column (so,
--this must be between 0-8), return the indexes for the column - which are
--gotten by incrementing by 9 until we're past 80.
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

getIndexesForBoxNumber :: Int -> [Int]
getIndexesForBoxNumber n = getIndexesForGrid ((n `div` 3) * 3, (n `mod` 3) * 3)

getIndexesForPeers :: (Int,Int) -> [Int]
getIndexesForPeers (row,column) = (getIndexesForRow (row*9)) ++ (getIndexesForColumn column) ++ (getIndexesForGrid (row,column))

getSolvedIndexes :: [[Int]] -> [(Int,Int)]
getSolvedIndexes pg = gsi 0 pg
  where
   gsi n [] = []
   gsi n (x:xs) = if (length x) == 1 then (head x,n) : gsi (n+1) xs else gsi (n+1) xs

getIndexedCells :: [[Int]] -> [(Int,[Int])]
getIndexedCells = zip [0..]

getPossibleCellsForNumber :: Int -> [(Int,[Int])] -> [Int]
getPossibleCellsForNumber _ [] = []
getPossibleCellsForNumber n ((i,possibilities):rest) = if n `elem` possibilities then i : getPossibleCellsForNumber n rest else getPossibleCellsForNumber n rest 

getPossibleCellsForNumbers :: [[Int]] -> [[Int]]
getPossibleCellsForNumbers pg = map ((flip getPossibleCellsForNumber) (getIndexedCells pg)) [1..9]

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

eliminateForLastRemainingInBox :: [[Int]] -> [[Int]]
eliminateForLastRemainingInBox pg =
  let
    possiblecellsbynumber = getPossibleCellsForNumbers pg
    cellsbybox = map getIndexesForBoxNumber [0..8]
  in
    cellsbybox

iterateUntilEqual :: (Eq a) => (a -> a) -> a -> a
iterateUntilEqual f i =
  let
    intermediate = f i
  in 
    if intermediate == i then intermediate else iterateUntilEqual f intermediate

eliminateForSolvedCellsStrategy :: [[Int]] -> [[Int]]
eliminateForSolvedCellsStrategy pg = iterateUntilEqual (eliminateForSolvedCells . markSolvedCells) pg

lastRemainingCellInBoxStrategy :: [[Int]] -> [[Int]]
lastRemainingCellInBoxStrategy pg = iterateUntilEqual eliminateForLastRemainingInBox pg

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

  
solveAndShow :: [[Int]] -> IO ()
solveAndShow pz = do
  putStrLn . printGrid $ pz
  putStrLn . printGrid . eliminateForSolvedCellsStrategy $ pz
  putStrLn "\n\n"

--main = print $ initGrid 0 $ take 81 (repeat 0)
main = 
  do
    input <- readFile "easy50.txt"
    let puzzles = map readPuzzle $ lines input
    putStrLn $ printGrid $ puzzles !! 2
    print $ getIndexedCells $ puzzles !! 2
    print $ (getPossibleCellsForNumber 9) . getIndexedCells $ puzzles !! 2
    print $ getPossibleCellsForNumbers $ puzzles !! 2
    print $ map getIndexesForBoxNumber [0..8]
    --let puzzle = readPuzzle $ ((!!2) . lines) input
    --mapM solveAndShow $ puzzles 
    --mapM (print . getIndexesForBoxNumber) [0..9]
    --mapM (putStrLn . printGrid) puzzles
    --putStr $ printGrid puzzle
    --putStrLn "\n\n"
    --print $ puzzle
    --putStrLn "\n\n"
    --print $ eliminateForSolvedCell puzzle (8,29)
    --putStrLn "\n\n"
    --putStrLn $ printGrid $ iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 8
    --putStrLn $ printGrid $ iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 9
    --putStrLn $ printGrid $ iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 10
    --putStrLn $ printGrid $ iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 11
    --print $ (iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 11) == (iterate (eliminateForSolvedCells . markSolvedCells) puzzle !! 10)
    --putStrLn $ printGrid $ eliminateForSolvedCellsStrategy puzzle
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

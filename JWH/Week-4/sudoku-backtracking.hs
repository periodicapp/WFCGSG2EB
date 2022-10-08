import Data.Char (digitToInt, intToDigit, chr)
import Data.List (intersperse, sort)

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

--removeItems takes a list of items and another list of items and removes any
--instance of a member of the first list from the second
removeItems :: [Int] -> [Int] -> [Int]
removeItems xs ys = foldr ($) ys (map removeItem xs)

--removePossibility takes an integer representing a value for a cell that is no
--longer possible for that cell and removes it from the list of possibilities.
--Because the representation used is a list of at most 10 items - with the head
--representing the current value of the cell and the tail representing the
--remaining possible values (when the cell hasn't been solved) - we do this by
--concatenating the existing head onto the result of removing the value from
--the tail
removePossibility :: Int -> [Int] -> [Int]
removePossibility _ [] = []
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

--unitIsSolved takes a function that fetches a unit (row, column or box) from a
--grid based on the index it's given, and a grid, and an index and applies the
--function.  Then it sorts the result and checks whether it's equal to
--[1,2,3,4,5,6,7,8,9].  If it is, the unit is solved.  If not, it's not.
unitIsSolved :: ([Int] -> Int -> [Int]) -> [Int] -> Int -> Bool
unitIsSolved f pg i = (sort $ f pg i) == [1..9]

--unitIsValid takes a function that fetches a unit (row, column or box) from a
--grid based on the index it's givn, and a grid, and an index, and applies the
--function.  Then it checks whether all the cell values returned are unique
--(barring 0).  If they are, the unit is valid.
unitIsValid :: ([Int] -> Int -> [Int]) -> [Int] -> Int -> Bool
unitIsValid f pg i = (allUniq $ f pg i) 

rowIsSolved :: [Int] -> Int -> Bool
rowIsSolved = unitIsSolved getRow

rowIsValid :: [Int] -> Int -> Bool
rowIsValid = unitIsValid getRow

columnIsSolved :: [Int] -> Int -> Bool
columnIsSolved = unitIsSolved getColumn

columnIsValid :: [Int] -> Int -> Bool
columnIsValid = unitIsValid getColumn

boxIsSolved :: [Int] -> Int -> Bool
boxIsSolved = unitIsSolved getBox

boxIsValid :: [Int] -> Int -> Bool
boxIsValid = unitIsValid getBox

--isSolved takes a puzzle grid and returns True if it is solved, False
--otherwise.  It does this by first converting it to just a grid of numbers,
--then checking whether all rows, 0-8, are solved, and whether all columns,
--0-8, are solved, and whether all boxes, 0-8, are solved
isSolved :: [[Int]] -> Bool
isSolved pg =
  let 
    grd = gridNumbers pg
    allrows = all (rowIsSolved grd) [0..8]
    allcolumns = all (columnIsSolved grd) [0..8]
    allboxes = all (boxIsSolved grd) [0..8]
  in
    allrows && allcolumns && allboxes

--allUniq takes a list of integers (representing cell values for a unit) and
--checks that there are no duplicates in the list other than 0 (which
--represents an unsolved cell and so doesnt count for validity checks)
allUniq :: [Int] -> Bool
allUniq [] = True
allUniq (x:xs)
  | x == 0 = allUniq xs
  | x `elem` xs = False
  |otherwise = allUniq xs

--isValid takes a (potentially unsolved) puzzle grid and determines whether all
--the constraints on the rows, columns and boxes are honored
isValid :: [[Int]] -> Bool
isValid pg =
  let
    pgs = gridNumbers pg
    allrows = all (rowIsValid pgs) [0..8]
    allcolumns = all (columnIsValid pgs) [0..8]
    allboxes = all (boxIsValid pgs) [0..8]
  in
    allrows && allcolumns && allboxes


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

--getIndexesForBox - given a 0-indexed (row,column) tuple, return the indexes
--of all the cells in the one-dimensional array reprentation of the puzzle that
--fall within that box
getIndexesForBox :: (Int,Int) -> [Int]
getIndexesForBox (row,column) =
  let
    rowoffset = (row `div` 3) * 3
    columnoffset = (column `div` 3) * 3
  in
    [x | rw <- [0,1,2], x <- (take 3) . (drop columnoffset) . getIndexesForRow $ ((rw+rowoffset)*9)]

--getIndexesForBoxNumber - given a number for a box (assuming we number boxes
--from 0 to 8 reading left-to-right and across from the top-left box to the
--bottom-right one) - return the indexes for all the cells in the
--one-dimensional array representation of the puzzle that fall within that box
getIndexesForBoxNumber :: Int -> [Int]
getIndexesForBoxNumber n = getIndexesForBox ((n `div` 3) * 3, (n `mod` 3) * 3)

--given a 0-indexed (row,column) tuple representing a cell, return the indexes
--of all the cells in the one-dimensional array representation of the puzzle
--that are in the same row, column, or box as that cell.  Note that this
--currently returns duplicates for overlap cells.
getIndexesForPeers :: (Int,Int) -> [Int]
getIndexesForPeers (row,column) = (getIndexesForRow (row*9)) ++ (getIndexesForColumn column) ++ (getIndexesForBox (row,column))

--getSolvedIndexes - given a one-dimensional array puzzle representation,
--return the values, paired with their indexes in the array of all the cells
--that are "solved" (in the sense of being length one arrays, with the one
--position representing the value of the cell; there are no more possible
--values to represent)
getSolvedIndexes :: [[Int]] -> [(Int,Int)]
getSolvedIndexes pg = gsi 0 pg
  where
   gsi n [] = []
   gsi n (x:xs) = if (length x) == 1 then (head x,n) : gsi (n+1) xs else gsi (n+1) xs

--getIndexedCells - given a one-dimensional array representation of a puzzle,
--return an array of each cell representation paired in a tuple with its index
getIndexedCells :: [[Int]] -> [(Int,[Int])]
getIndexedCells = zip [0..]

--removePossibilityFromCells - given an array-of-cells representation of a
--puzzle and a list of indexes of cells to affect, and a value to remove,
--remove the value from each of the cells indicated by the indexes, returning
--the modified array-of-cells representation of the puzzle
removePossibilityFromCells :: [[Int]] -> [Int] -> Int -> Int -> [[Int]]
removePossibilityFromCells [] _ _ _ = []
removePossibilityFromCells (cell:cells) indexes current value
  | current `elem` indexes = (removePossibility value cell) : (removePossibilityFromCells cells indexes (current+1) value)
  | otherwise = cell : removePossibilityFromCells cells indexes (current+1) value
  

--solveCellForNumberAtIndex - takes an array-of-cells representation of a
--puzzle, a number, and an index and replaces the cell at the indicated index
--with a cell "solved" for the given number.  It does this by converting the
--array-of-cells to an array of tuples pairing cells with their index and then
--iterates over the list until it finds the tuple with the right index.
solveCellForNumberAtIndex :: [[Int]] -> Int -> Int -> [[Int]]
solveCellForNumberAtIndex pg num idx = replacer (getIndexedCells pg) num idx
  where
    replacer [] _ _ = []
    replacer ((i,cl):cls) n ix = if i == ix then [num] : replacer cls num idx else cl : replacer cls num idx

solveCellForNumberAtIndexTuple :: (Int,Int) -> [[Int]] -> [[Int]]
solveCellForNumberAtIndexTuple (n,i) pg = solveCellForNumberAtIndex pg n i


--eliminateForSolvedCell - once a cell is "solved," no other cells in its row,
--column or box can share a value with it.  So, given a (row,column)
--representation of a cell, remove the value from the possibilities list of all
--of its "peers" - that is, from all the cells in the same column, row or box
--with it.
eliminateForSolvedCell :: (Int,Int) -> [[Int]] -> [[Int]]
eliminateForSolvedCell (value, index) pg  =
  let
    peerIndexes = getIndexesForPeers (getCoordinatesFromIndex index)
  in
    removePossibilityFromCells pg peerIndexes 0 value

--eliminateForSolvedCell - given an array-of-cells representation of a puzzle,
--identify all the cells that are "solved" and call "eleminateSolvedCell" for
--each, making sure that values for each solved cell are removed from the
--possibilities for each of their row, column and box neighbors.  This is a
--"strategy" function.
eliminateForSolvedCells :: [[Int]] -> [[Int]]
eliminateForSolvedCells pg =
  let
    solvedindexes = getSolvedIndexes pg
  in
    foldr eliminateForSolvedCell pg solvedindexes


--getNextUnsolvedCell takes an array-of-cells representation of a puzzle and
--returns the next unsolved cell in the form of a tuple.  The right member of
--the tuple is the array representation of the cell, and the left member is the
--index in the array at which it was found.
getNextUnsolvedCell :: [[Int]] -> (Int,[Int])
getNextUnsolvedCell pg = gnuc $ zip [0..] pg
  where
    gnuc [] = (82,[])
    gnuc ((i,ps):pss) = if (length ps) > 1 then (i,ps) else gnuc pss


--gateSolution implements the branching part of the backtracking algorithm.
--When we hit an unsolved cell, there will be several possibilities for its
--value, and we have to try all of them.  Some of them will fail.  This
--function takes a list of partially-solved puzzle grids and tries each one in
--turn (by calling applyBacktrackingStrategy on it).  If this results in
--failure, it goes to the next item in the list.  If it succeeds, we've found a
--solution, so no need to try any other possibilities; just return it.
gateSolution :: [[[Int]]] -> Maybe [[Int]]
gateSolution [] = Nothing
gateSolution (pg:pgs) = 
  case applyBacktrackingStrategy pg of
    (Just x) -> Just x
    Nothing -> gateSolution pgs

--applyNextCell works with gateSolution to apply the branching part of the
--backtracking algorithm.  The whole thing works by taking a partially solved
--puzzle and finding the next empty/unsolved cell.  Then, for each possible
--value of that cell, we first apply the value and then call (recursively)
--applyBacktrackingStrategy on the result of "solving" the cell for that value.
--This can either succeed or fail, so we "gate" the result with a call to
--gateSolution to make sure we return early if one of the possibilities
--generates a path to success.
applyNextCell :: [[Int]] -> Maybe [[Int]]
applyNextCell pg = 
  let
    nextunsolved = getNextUnsolvedCell pg
    index = fst nextunsolved
    possibilities = tail . snd $ nextunsolved
  in
    if index == 82 then Nothing else gateSolution $ map (\x -> solveCellForNumberAtIndex pg x index) possibilities

--applyBacktrackingStrategy is the driver function.  Takes a puzzle grid,
--reduces the possibilities on each cell based on what's "solved," and then
--determies whether the puzzle is already solved.  If so, return it.  If
--complete but not solved, it's a failure.  If it's valid but not complete,
--pass it to a function applyNextCell that will recursively call this function
--on the result of solving the next free/unsolved cell with each remaining
--possible value for that cell in turn.  This process ends at the first
--successful solution.
applyBacktrackingStrategy :: [[Int]] -> Maybe [[Int]]
applyBacktrackingStrategy pg
  | (isValid pgs) && (isComplete pgs) = Just pgs
  | (isComplete pgs) = Nothing
  | (isValid pgs) = applyNextCell pgs
  | otherwise = Nothing
  where
    pgs = eliminateForSolvedCellsStrategy pg

--iterateUntilEqual - is a way of running the same strategy function over a
--puzzle as long as "needed."  It is used to run the strategy function over the
--puzzle, returning a new representation of the puzzle, which it then feeds
--back to the same function repeatedly until the output stops changing
iterateUntilEqual :: (Eq a) => (a -> a) -> a -> a
iterateUntilEqual f i =
  let
    intermediate = f i
  in 
    if intermediate == i then intermediate else iterateUntilEqual f intermediate

eliminateForSolvedCellsStrategy :: [[Int]] -> [[Int]]
eliminateForSolvedCellsStrategy pg = iterateUntilEqual (eliminateForSolvedCells . markSolvedCells) pg

getRow :: [Int] -> Int -> [Int]
getRow grd i = getItemsAtIndexes grd (getIndexesForRow (i*9))

getColumn :: [Int] -> Int -> [Int]
getColumn grd i = getItemsAtIndexes grd (getIndexesForColumn i)

getGrid :: [Int] -> (Int,Int) -> [Int]
getGrid grd (row,column) = getItemsAtIndexes grd (getIndexesForBox (row,column))
    
getBox :: [Int] -> Int -> [Int]
getBox grd i = getItemsAtIndexes grd (getIndexesForBoxNumber i)

--getCoordinatesFromIndex - given the index of a cell in an array-of-cells
--representation of a puzzle, return the (row,column) tuple for that cell
getCoordinatesFromIndex :: Int -> (Int,Int)
getCoordinatesFromIndex i = (i `div` 9, i `mod` 9)

--printGrid takes a puzzle and converts it to a string in which the cells are
--laid out in rows and separated into boxes
printGrid :: [[Int]] -> [Char]
printGrid = (foldr (++) "") . renderGridLine . gridNumbers

print_rows pz = do
  mapM print $ chunksOf 9 pz

solveBacktracking pz = do
  putStrLn . printGrid $ pz
  let solved = applyBacktrackingStrategy pz
  case solved of
    Nothing -> putStrLn "No Solution Found"
    (Just x) -> putStrLn . printGrid $ x
  putStrLn "\n\n"

main = 
  do
    --input <- readFile "someinvalid.txt"
    input <- readFile "easy50.txt"
    --input <- readFile "top95-0.txt"
    let puzzles = map readPuzzle $ lines input
    mapM solveBacktracking $ puzzles 

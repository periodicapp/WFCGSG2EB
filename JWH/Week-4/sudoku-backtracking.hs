import Data.Char (digitToInt, intToDigit, chr)
import Data.List (intersperse, sort)

intersection :: (Eq a) => [a] -> [a] -> [a]
intersection xs ys = [y | y <- ys, y `elem` xs]
  
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

--getUnsolvedIndexes - takes a grid and iterates over it, incrementing an index
--counter each time, returning a list of the indexes of all the elements in the
--grid that are unsolved - i.e. have a possibilities list (meaning their length
--is greater than 1)
getUnsolvedIndexes :: [[Int]] -> [Int]
getUnsolvedIndexes pg = gusi 0 pg
  where
    gusi _ [] = []
    gusi n (x:xs) = if (length x) > 1 then n : gusi (n+1) xs else gusi (n+1) xs

--getIndexedCells - given a one-dimensional array representation of a puzzle,
--return an array of each cell representation paired in a tuple with its index
getIndexedCells :: [[Int]] -> [(Int,[Int])]
getIndexedCells = zip [0..]

--getPossibleCellsForNumber - given a number (1-9) and a "getIndexedCells"
--representation of the puzzle, return all the cells for which that number is a
--possible value (in the sense of being in the tail of the representation [Int]
--list for that cell)
getPossibleCellsForNumber :: Int -> [(Int,[Int])] -> [Int]
getPossibleCellsForNumber _ [] = []
getPossibleCellsForNumber n ((i,possibilities):rest) = if n `elem` possibilities then i : getPossibleCellsForNumber n rest else getPossibleCellsForNumber n rest 

--getPossibleCellsForNumbers - takes a one-dimensional array representation of
--a puzzles and calls "getPossibleCellsForNumber" on it for each number 1-9 -
--i.e. for each possible value of a cell.
getPossibleCellsForNumbers :: [[Int]] -> [[Int]]
getPossibleCellsForNumbers pg = map ((flip getPossibleCellsForNumber) (getIndexedCells pg)) [1..9]

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


--getSingleOptionNumbers - takes a list of lists of indexes and returns
--pairings of number and index to feed into solveCellForNumberAtIndex - that
--is, it will be a list of tuples the left member of which is a number to put
--in a cell and the right member of which is the index of the cell in the
--array-of-cells puzzle representation.  The input list of lists of indexes is
--arranged in such a way that the list of indexes is at the place in the master
--list that corresponds to the number.  (So, the first list of indexes in the
--list represents the indexes of cells that have 1 as a possible value, the
--next for 2 and so on.)  So, this function just pulls out all the ones that
--are length 1, since if a cell in a context is the only cell that can have
--that number as the value, then it must also have that number as the value.
getSingleOptionNumbers :: [[Int]] -> [(Int,Int)]
getSingleOptionNumbers cells = [(num,head idx) | (num,idx) <- (zip [1..] cells), length idx == 1]


--possibilitiesEq = takes two lists and returns true if their tails are equal.
--This is used to detect cells that are equal in terms of their possibilities
--lists
possibilitiesEq :: [Int] -> [Int] -> Bool
possibilitiesEq (x:xs) (y:ys) = xs == ys

--findRepeatedPossibilities - takes a list of cells and retains the first of
--any that have a possibilities list that is duplicated by a later cell in the
--list
findRepeatedPossibilities :: [[Int]] -> [[Int]]
findRepeatedPossibilities [] = []
findRepeatedPossibilities (x:xs) = if any (possibilitiesEq x) xs then x : findRepeatedPossibilities xs else findRepeatedPossibilities xs

--findNakedPairs - takes a list of lists of Int, each representing a cell in
--the puzzle, and returns the ones that have exactly two remaining items in
--their possibilities list
findNakedPairs :: [[Int]] -> [[Int]]
findNakedPairs cells = findRepeatedPossibilities $ (filter (\x -> length x == 3) cells)

--eliminateNakedPairFromCell - takes a list of Int representing a "naked pair"
--that's been discovered.  (In practice, this will be a list of exactly two
--numbers.)  Then, takes a list of Int representing a cell.  If the pair is
--equal to the tail of the cell, leave it alone because this is one of the
--cells that identified the pair (i.e. this is one of the cells that *must*
--have one of these two values as its solution value)!  Otherwise, remove the
--two values from the possibilities list of the cell.
eliminateNakedPairFromCell :: [Int] -> [Int] -> [Int]
eliminateNakedPairFromCell pair cell 
  | cell == [] = []
  | pair == [] = cell
  | pair == (tail cell) = cell
  | otherwise = (head cell) : (removeItems pair (tail cell))

--eliminateNakedPairFromIndexes - takes a list of indexes ([Int]) and an int
--representing the current place in the iteration loop, and a list of Int
--representing an identified "naked pair" (in practice, this will be a list of
--exactly two Ints) and then a list of cells which are candidates for having
--their possibilities list reduced by the pair.  Cells in the list are EITHER
--(a) cells which form the "naked pair" (there should be exactly two of these)
--and so should NOT have the pair removed from their possibilities list or (b)
--cells which do not form the "naked pair" and so should have both items in the
--pair removed from their possibilities list.  This uses the helper function
--eliminateNakedPairFromIndexes to both tell which is which and apply the
--reduction where appropriate.
eliminateNakedPairFromIndexes :: [Int] -> Int -> [Int] -> [[Int]] -> [[Int]]
eliminateNakedPairFromIndexes _ _ _ [] = []
eliminateNakedPairFromIndexes idxs current pair (cell:cells)
  | current `elem` idxs = (eliminateNakedPairFromCell pair cell) : eliminateNakedPairFromIndexes idxs (current+1) pair cells
  | otherwise = cell : eliminateNakedPairFromIndexes idxs (current+1) pair cells

--PLACEHOLDER
--NEXT
--1. implement findPointingPairs - note that this will need to preserve indexes
--2. implement functions that can reconstruct the OTHER unit indexes might be a member of.  
--3. If they turn out to be in another unit, eliminate the pair from that unit
--4. Probably best to do (3) with a "remove unit but spare these indexes" type of function
--
eliminateForPointingPairsInUnit :: (Int -> [Int]) -> Int -> [[Int]] -> [[Int]]
eliminateForPointingPairsInUnit f n pg = 
  let 
    indexes = f n
    cells = getItemsAtIndexes pg indexes
    --pointingpairs = map tail $ findPointingPairs cells
  in
    pg

{-
 - What follows is the "strategy" section.  A "strategy" is a known technique
 - for eliminating possibilities from cells.  The solver works by seeding all
 - cells with all possible values, "solving" the cells in the initial test
 - input, and then iteratively removing possible values from the remaining
 - "unsolved" cells based on deductions made from the configuration of the
 - board.  This is done by "strategy functions," which all have the signature
 - [[Int]] -> [[Int]] - that is, they take in a puzzle grid and return a(n
 - updated) puzzle grid.  Lots of strategies use the concept of a "unit" -
 - which is a cluster of cells that are constrained to have only one value from
 - 1,2,3,4,5,6,7,8,9 each.  So - "unit" means either row, column or box.  For
 - that reason, lots of strategies have an abstracted version that operates on
 - the "unit" level, and they work by passing in a function to the abstracted
 - "unit"-level function that is responsible for getting the indexes relevant
 - to the unit currently being operated on.  For example,
 - eliminateForLastRemainingInBox is a function that uses
 - eliminateForLastRemainingInUnit to implement the "eliminate for last
 - remaining" strategy at the box level.  Given a number indicating a box and a
 - puzzle grid, it applies the "elminate for last remaining" strategy to that
 - box.  This is called from the eliminateForLastRemainingInBoxStrategy
 - function, which takes responsibility for making further deductions about the
 - puzzle based on the result of that.
 -}

getNextUnsolvedCell :: [[Int]] -> (Int,[Int])
getNextUnsolvedCell pg = gnuc $ zip [0..] pg
  where
    gnuc [] = (82,[])
    gnuc ((i,ps):pss) = if (length ps) > 1 then (i,ps) else gnuc pss

gateSolution :: [[[Int]]] -> Maybe [[Int]]
gateSolution [] = Nothing
gateSolution (pg:pgs) = 
  case applyBacktrackingStrategy pg of
    (Just x) -> Just x
    Nothing -> gateSolution pgs

applyNextCell :: [[Int]] -> Maybe [[Int]]
applyNextCell pg = 
  let
    nextunsolved = getNextUnsolvedCell pg
    index = fst nextunsolved
    possibilities = tail . snd $ nextunsolved
  in
    if index == 82 then Nothing else gateSolution $ map (\x -> solveCellForNumberAtIndex pg x index) possibilities

applyBacktrackingStrategy :: [[Int]] -> Maybe [[Int]]
applyBacktrackingStrategy pg
  | (isValid pgs) && (isComplete pgs) = Just pgs
  | (isComplete pgs) = Nothing
  | (isValid pgs) = applyNextCell pgs
  | otherwise = Nothing
  where
    pgs = eliminateForSolvedCellsStrategy pg

eliminateForNakedPairsInUnit :: (Int -> [Int]) -> Int -> [[Int]] -> [[Int]]
eliminateForNakedPairsInUnit f n pg =
  let
    indexes = f n
    cells = getItemsAtIndexes pg indexes
    nakedpairs = map tail $ findNakedPairs cells
  in
    if (length nakedpairs) == 0 then pg else foldr (eliminateNakedPairFromIndexes indexes 0) pg nakedpairs

eliminateForLastRemainingInUnit :: (Int -> [Int]) -> Int -> [[Int]] -> [[Int]]
eliminateForLastRemainingInUnit f n pg = 
  let
    possiblecellsbynumber = getPossibleCellsForNumbers pg
    cellsbybox = f n
    overlap = map (intersection cellsbybox) possiblecellsbynumber
    relevant = getSingleOptionNumbers overlap
  in
    foldr solveCellForNumberAtIndexTuple pg relevant

eliminateForLastRemainingInBox :: Int -> [[Int]] -> [[Int]]
eliminateForLastRemainingInBox = eliminateForLastRemainingInUnit getIndexesForBoxNumber

eliminateForLastRemainingInRow :: Int -> [[Int]] -> [[Int]]
eliminateForLastRemainingInRow = eliminateForLastRemainingInUnit (\x -> getIndexesForRow (x*9))

eliminateForLastRemainingInColumn :: Int -> [[Int]] -> [[Int]]
eliminateForLastRemainingInColumn = eliminateForLastRemainingInUnit getIndexesForColumn

eliminateForNakedPairsInBox :: Int -> [[Int]] -> [[Int]]
eliminateForNakedPairsInBox = eliminateForNakedPairsInUnit getIndexesForBoxNumber

eliminateForNakedPairsInRow :: Int -> [[Int]] -> [[Int]]
eliminateForNakedPairsInRow = eliminateForNakedPairsInUnit (\x -> getIndexesForRow (x*9))

eliminateForNakedPairsInColumn :: Int -> [[Int]] -> [[Int]]
eliminateForNakedPairsInColumn = eliminateForNakedPairsInUnit getIndexesForColumn

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

eliminateForLastRemainingInBoxStrategy :: [[Int]] -> [[Int]]
eliminateForLastRemainingInBoxStrategy pg = iterateUntilEqual (\x -> eliminateForSolvedCellsStrategy $ (foldr eliminateForLastRemainingInBox x [0..8])) pg

eliminateForLastRemainingInRowStrategy :: [[Int]] -> [[Int]]
eliminateForLastRemainingInRowStrategy pg = iterateUntilEqual (\x -> eliminateForSolvedCellsStrategy $ (foldr eliminateForLastRemainingInRow x [0..8])) pg

eliminateForLastRemainingInColumnStrategy :: [[Int]] -> [[Int]]
eliminateForLastRemainingInColumnStrategy pg = iterateUntilEqual (\x -> eliminateForSolvedCellsStrategy $ (foldr eliminateForLastRemainingInColumn x [0..8])) pg

eliminateForNakedPairsInBoxStrategy :: [[Int]] -> [[Int]]
eliminateForNakedPairsInBoxStrategy pg = iterateUntilEqual (\x -> eliminateForSolvedCellsStrategy $ (foldr eliminateForNakedPairsInBox x [0..8])) pg

eliminateForNakedPairsInRowStrategy :: [[Int]] -> [[Int]]
eliminateForNakedPairsInRowStrategy pg = iterateUntilEqual (\x -> eliminateForSolvedCellsStrategy $ (foldr eliminateForNakedPairsInRow x [0..8])) pg

eliminateForNakedPairsInColumnStrategy :: [[Int]] -> [[Int]]
eliminateForNakedPairsInColumnStrategy pg = iterateUntilEqual (\x -> eliminateForSolvedCellsStrategy $ (foldr eliminateForNakedPairsInColumn x [0..8])) pg

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

--getIndexFromCoordinates - given the (row,column) representation of a cell in
--a puzzle, return the index in the array-of-cells representation it
--corresponds to
getIndexFromCoordinates :: (Int,Int) -> Int
getIndexFromCoordinates (i,j) = (i*9) + j

--printGrid takes a puzzle and converts it to a string in which the cells are
--laid out in rows and separated into boxes
printGrid :: [[Int]] -> [Char]
printGrid = (foldr (++) "") . renderGridLine . gridNumbers

solveAndShow :: [[Int]] -> IO ()
solveAndShow pz = do
  putStrLn . printGrid $ pz
  let fullsolution = eliminateForLastRemainingInBoxStrategy . eliminateForLastRemainingInColumnStrategy . eliminateForLastRemainingInRowStrategy . eliminateForNakedPairsInBoxStrategy . eliminateForNakedPairsInColumnStrategy . eliminateForNakedPairsInRowStrategy . eliminateForLastRemainingInBoxStrategy .  eliminateForLastRemainingInColumnStrategy . eliminateForLastRemainingInRowStrategy . eliminateForSolvedCellsStrategy $ pz
  putStrLn . printGrid $ fullsolution
  print_rows fullsolution
  putStrLn "\n"
  print $ isComplete $ fullsolution
  print $ isSolved $ fullsolution
  putStrLn "\n\n"

print_rows pz = do
  mapM print $ chunksOf 9 pz

debug pz = do
  putStrLn . printGrid $ pz
  let first_pass = eliminateForSolvedCellsStrategy $ pz
  let second_pass = eliminateForLastRemainingInBoxStrategy first_pass
  let third_pass = eliminateForLastRemainingInRowStrategy second_pass
  let fourth_pass = eliminateForLastRemainingInColumnStrategy third_pass
  let fifth_pass = eliminateForNakedPairsInRowStrategy fourth_pass
  let sixth_pass = eliminateForNakedPairsInColumnStrategy fifth_pass
  let seventh_pass = eliminateForNakedPairsInBoxStrategy sixth_pass
  let eighth_pass = eliminateForLastRemainingInRowStrategy seventh_pass
  let ninth_pass = eliminateForLastRemainingInColumnStrategy eighth_pass
  let tenth_pass = eliminateForLastRemainingInBoxStrategy ninth_pass
  putStrLn . printGrid $ first_pass
  print_rows first_pass
  putStrLn "\n\n"
  putStrLn . printGrid $ second_pass
  print_rows second_pass
  putStrLn "\n\n"
  putStrLn . printGrid $ third_pass
  print_rows third_pass
  putStrLn "\n\n"
  putStrLn . printGrid $ fourth_pass
  print_rows fourth_pass
  putStrLn "\n\n"
  putStrLn . printGrid $ fifth_pass
  print_rows fifth_pass
  putStrLn "\n\n"
  putStrLn . printGrid $ sixth_pass
  print_rows sixth_pass
  putStrLn "\n\n"
  putStrLn . printGrid $ seventh_pass
  print_rows seventh_pass
  putStrLn "\n\n"
  putStrLn . printGrid $ eighth_pass
  print_rows eighth_pass
  putStrLn "\n\n"
  putStrLn . printGrid $ ninth_pass
  print_rows ninth_pass
  putStrLn "\n\n"
  putStrLn . printGrid $ tenth_pass
  print_rows tenth_pass
  putStrLn "\n\n"
  print $ isComplete tenth_pass
  print $ isSolved tenth_pass
  putStrLn "\n\n"

solveBacktracking pz = do
  putStrLn . printGrid $ pz
  let solved = applyBacktrackingStrategy pz
  print $ solved
  putStrLn "\n\n"

main = 
  do
    --input <- readFile "someinvalid.txt"
    input <- readFile "easy50.txt"
    let puzzles = map readPuzzle $ lines input
    mapM solveBacktracking $ puzzles 
    --mapM solveAndShow $ puzzles 
    --mapM debug $ puzzles 
    --debug $ readPuzzle "380000000000400785009020300060090000800302009000040070001070500495006000000000092"
    --solveBacktracking $ readPuzzle "100920000524010000000000070050008102000000000402700090060000000000030945000071006"

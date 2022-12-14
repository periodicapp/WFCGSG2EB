--flattenMatrix takes a list of lists of Int - i.e. a matrix - and flattens it
--to a one-dimensional array.  This is done for efficiency - it's easier to
--calculate the corresponding position of a cell in a flattened array and
--access it directly than it is to iterate over rows and columns finding it
flattenMatrix :: [[Int]] -> [Int]
flattenMatrix = foldl1 (++)


--getMatrixDimensions takes a list of lists of Int - i.e. a matrix - and
--returns a tuple representing the length of the dimensions (n,m).  For
--example, the matrix [[1,2,3],[4,5,6]] would return (2,3)
getMatrixDimensions :: [[Int]] -> (Int,Int)
getMatrixDimensions m = (length m, (length . head) m)


--getSurrounding - given a tuple of Int representing the coordinates (n,m) of a
--cell in a matrix, return a list of the coordinates of all the cells that
--immediately surrond it - i.e. the one just to the top, just to the bottom,
--just to the left, and just to the right.  So, for example, (1,2) should
--return [(0,2),(2,2),(2,1),(2,3)]
getSurrounding :: (Int,Int) -> [(Int,Int)]
getSurrounding (n,m) = [(n-1,m), (n+1,m), (n,m-1), (n,m+1)]

--getIndexFromCoordinates - given the width of a matrix m and a pair of
--coordinates (i,j), return the corresponding index in a flattened
--(one-dimensional) array represnting the matrix for that cell
getIndexFromCoordinates :: Int -> (Int,Int) -> Int
getIndexFromCoordinates m (i,j) = i*m+j

--getSurroundingIndexes - given the width of a matrix m and a pair of
--coordinates (i,j), return a list of indexes representing the surrounding
--cells in a flattened (one-dimensional) representation of the matrix
getSurroundingIndexes :: Int -> (Int,Int) -> [Int]
getSurroundingIndexes m = (map $ getIndexFromCoordinates m) . getSurrounding

--getSurroundingCellValues - given a flattened representation of a matrix mat,
--the width of the original matrix m, and a pair of coordinates (i,j), return
--the values of the surrounding cells of the cell represented by the coordinate
--pair
getSurroundingCellValues :: [Int] -> Int -> (Int,Int) -> [Int]
getSurroundingCellValues mat m (i,j) = 
  let
    indexes = getSurroundingIndexes m (i,j)
  in
    map (mat!!) indexes

--getCD - helper function for getCellDepth.  Given the value of a cell v and
--the values of its surrounding cells vs, return the "depth" of the cell - that
--is, how "deep" the pool formed by the cells surrounding this cell are,
--assuming that they are all higher than the given cell (if any one of them is
--not, return 0)
getCD :: Int -> [Int] -> Int
getCD v vs = 
  let
    m = foldl1 min vs
  in
    if m <= v then 0 else m - v

--getCellDepth - given a flattened matrix mat and a matrix width m and a
--coordinate pair (i,j), return the "depth" of the cell represented by (i,j) in
--the source matrix.  Do this by getting the value of the cell represented by
--(i,j) and the values of all its surrounding cells and passing them to a
--helper function
getCellDepth :: [Int] -> Int -> (Int,Int) -> Int
getCellDepth mat m (i,j) =
  let
    vals = getSurroundingCellValues mat m (i,j)
    v = mat !! (getIndexFromCoordinates m (i,j))
  in
    getCD v vals

--getInteriorRow - get the coordinates for all the cells in row n except the
--two on each end
getInteriorRow :: Int -> Int -> [(Int,Int)]
getInteriorRow m n = [(n,x) | x <- [1..m-2]]

--getInteriorCellCoordinates - given the dimensions of a matrix as a tuple
--(n,m), return the coordinates of all the interior cells - i.e. the
--coordinates of all the cells that are not on any of the edges.  Note that in
--some cases there are no cells which are "interior" in this sense; in those
--cases, return []
getInteriorCellCoordinates :: (Int,Int) -> [(Int,Int)]
getInteriorCellCoordinates (n,m)
  | n <= 2 = []
  | m <= 2 = []
  | otherwise = foldl1 (++) $ map (getInteriorRow m) [1..n-2]

getTotalVolume :: [[Int]] -> Int
getTotalVolume mat = 
  let
    mt = flattenMatrix mat
    (n,m) = getMatrixDimensions mat
    coords = getInteriorCellCoordinates (n,m)
  in
    sum $ map (getCellDepth mt m) coords

--main = print $ flattenMatrix [[1,2,3],[4,5,6],[7,8,9]]
--main = print $ getMatrixDimensions [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
--main = print $ getSurrounding (1,2)
--main = print $ getIndexFromCoordinates 4 (0,0)
--main = print $ getSurroundingIndexes 4 (1,2)
--main = print $ getSurroundingCellValues (flattenMatrix [[1,2,3,4],[5,6,7,8],[9,10,11,12]]) 4 (1,2)
--main = print $ getCellDepth (flattenMatrix [[1,4,3,1,3,2],[3,2,1,3,2,4],[2,3,3,2,3,1]]) 6 (1,2)
--main = print $ getInteriorCellCoordinates (3,6)
main = print $ getTotalVolume [[1,4,3,1,3,2],[3,2,1,3,2,4],[2,3,3,2,3,1]]



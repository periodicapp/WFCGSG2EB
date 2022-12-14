--getPeaks takes a list of Int rw and an Int h and returns a list of 1s and 0s
--of the same length as rw where each 1 represents a number that is greater
--than or equal to h, 0 anything less than that
getPeaks :: [Int] -> Int -> [Int]
getPeaks rw h = [if x >= h then 1 else 0 | x <- rw]

--trimZeros takes a list of 1s and 0s and removes any 0s from either end.  This
--is called on the result of getPeaks (see above).  Basically, the remaining
--list is a list of 1s at either end with 0s and 1s between them which
--represents cells that contain water (the 0s) or hold it in (the 1s).  Summing
--the 0s in this list gives the total number of cells at the current level that
--contain water
trimZeros :: [Int] -> [Int]
trimZeros = reverse . (dropWhile (==0)) . reverse . (dropWhile (==0))

--sumContained sums the 0s in a list of 1s and 0s.  This receives the input of
--first applying getPeaks and trimZeros to an input list, given a height.  It
--represents the number of cells at a given level that can contain water.
sumContained :: [Int] -> Int
sumContained = length . filter (==0)

--getSliceVolume takes a list of [Int] rw representing an elevation map and an
--Int h representing the height of a "slice" of this list and returns the
--number of cells at that level that can contain water.  It does this by
--calling getPeaks to convert the list in to a series of 1s and 0s - where 1 is
--any height greater than or equal to the current level, and 0 any height below
--it - then using trimZeros to trim off the 0s on the edges, and then  calling
--sumContained to total the count of the remaining 0s.  This is the number of
--cells at the given level h that can containe water.
getSliceVolume :: [Int] -> Int -> Int
getSliceVolume rw h = sumContained . trimZeros $ getPeaks rw h

--getTotalContained takes a list of [Int] rw representing an elevation map and
--uses getSliceVolume to find the number of cells at each "level" that can
--contain water.  The answer to the problem is the sum of this number at each
--level.  The starting level is whatever the maximum height is, and each other
--level is obtained by iteratively subtracting 1 from the each level on
--downward.
getTotalContained :: [Int] -> Int
getTotalContained rw = 
  let
    mx = foldl1 max rw
  in
    sum $ map (getSliceVolume rw) [mx, (mx-1)..1]
  

--main = print $ getPeaks [0,1,0,2,1,0,1,3,2,1,2,1] 2
--main = print $ trimZeros $ getPeaks [0,1,0,2,1,0,1,3,2,1,2,1] 2
--main = print $ getSliceVolume [0,1,0,2,1,0,1,3,2,1,2,1] 3

--main = print $ getTotalContained [0,1,0,2,1,0,1,3,2,1,2,1]
main = print $ getTotalContained [4,2,0,3,2,5]

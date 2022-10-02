import Data.Char (digitToInt, intToDigit, chr)
import Data.List (intersperse)

data PuzzleGrid = PuzzleGrid [[Int]]
  deriving (Show)

initGrid :: Int -> [Int] -> [[Int]]
initGrid i = map (\x -> x:(take 10 (repeat i))) 

convertString :: [Char] -> [Int]
convertString = map digitToInt

gridNumbers :: PuzzleGrid -> [Int]
gridNumbers (PuzzleGrid pg) = map head pg

readPuzzle :: [Char] -> PuzzleGrid 
readPuzzle = PuzzleGrid . (initGrid 0) . convertString

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

printGrid :: PuzzleGrid -> [Char]
printGrid (PuzzleGrid pg) = (foldr (++) "") . renderGridLine . gridNumbers $ (PuzzleGrid pg)

--main = print $ initGrid 0 $ take 81 (repeat 0)
main = 
  do
    input <- readFile "top95-0.txt"
    mapM (putStr . printGrid . readPuzzle) $ lines $ input
    --print $ gridNumbers $ readPuzzle $ ((!!0) . lines) input
    --putStr $ printGrid $ readPuzzle $ ((!!0) . lines) input
    --print $ readPuzzle $ ((!!0) . lines) input

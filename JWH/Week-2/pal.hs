isEvenKernel :: Int -> [Char] -> Bool
isEvenKernel a chs = chs !! a == chs !! (a+1)

isOddKernel :: Int -> [Char] -> Bool 
isOddKernel a chs = chs !! a == chs !! (a+2)

getEvenKernels :: Int -> Int -> [Char] -> [Int] -> [Int]
getEvenKernels s e chs acc
  | s > e = acc 
  | isEvenKernel s chs = getEvenKernels (s+1) e chs (s:acc)
  | otherwise = getEvenKernels (s+1) e chs acc

getOddKernels :: Int -> Int -> [Char] -> [Int] -> [Int]
getOddKernels s e chs acc
  | s > e = acc 
  | isOddKernel s chs = getOddKernels (s+1) e chs (s:acc)
  | otherwise = getOddKernels (s+1) e chs acc

allOddKernels :: [Char] -> [Int]
allOddKernels chs = 
  let 
    start = 0
    end = (length chs) - 3
  in
    getOddKernels start end chs []

allEvenKernels :: [Char] -> [Int]
allEvenKernels chs = 
  let 
    start = 0
    end = (length chs) - 2
  in
    getEvenKernels start end chs []

expandPalindrome :: [Char] -> (Int,Int) -> (Int,Int)
expandPalindrome chs (a,b)
  | a == 0 = (a,b)
  | b == (length chs) - 1 = (a,b)
  | chs !! (a-1) == chs !! (b+1) = expandPalindrome chs (a-1,b+1)
  | otherwise = (a,b)

allPalindromes :: [Char] -> [(Int,Int)]
allPalindromes input = 
  let
    evens = [(i,i+1) | i <- allEvenKernels input]
    odds = [(j,j+2) | j <- allOddKernels input]
    expand = expandPalindrome input
  in
    (map expand evens) ++ (map expand odds)

maximumPair :: [(Int,Int)] -> (Int,Int) -> Int -> (Int,Int)
maximumPair ((i,j):xs) cand l
  | (length xs) == 0 && j - i > l = (i,j)
  | (length xs) == 0 = cand
  | j - i > l = maximumPair xs (i,j) (j-i)
  | otherwise = maximumPair xs cand l
    
maxPair :: [(Int,Int)] -> (Int,Int)
maxPair ((i,j):iss) = maximumPair ((i,j):iss) (i,j) (j-i)
maxPair [] = (0,-1)

maximumPalindrome :: [Char] -> [Char]
maximumPalindrome input = 
  let
    (i,j) = maxPair $ allPalindromes input
  in
    take (j-i+1) . drop i $ input
    

--main = print $ isEvenKernel 0 "abb"
--main = print $ isOddKernel 3 "ababac"
--main = print $ allOddKernels "ababac"
--main = print $ allEvenKernels "ababac"
--main = print $ allEvenKernels "abbbac"
--main = print $ allOddKernels "abbbac"
--main = print $ expandPalindrome (1,3) "abbbac"
--main = print $ expandPalindrome (2,4) "dabbbac"
--main = print $ expandPalindrome (3,4) "dabbbbac"
--main = print $ maxPair $ allPalindromes "dabbbbac"
--main = print $ maximumPalindrome "dabbbbac"
--main = print $ maximumPalindrome "cbbd"
main = print $ maximumPalindrome "abcdefg"

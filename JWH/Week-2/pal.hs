--isEvenKernel takes an index and a string and returns True if this index
--points to the first of two adjacent identical characters, False otherwise.
isEvenKernel :: Int -> [Char] -> Bool
isEvenKernel a chs = chs !! a == chs !! (a+1)

--isOddKernel takes a index and a string and returns True if this index points
--to the first of a triple of characters where the first and last are
--identical, False otherwise.
isOddKernel :: Int -> [Char] -> Bool 
isOddKernel a chs = chs !! a == chs !! (a+2)

--getEvenKernels is the implementation of allEvenKernels.  Takes a start and an
--end position, an input string and an accumulator.  For each index that is the
--start of an "even kernel" (that is, the potential center of an even-length
--palindrome - i.e. a pair of identical characters) it adds it to the
--accumulator list.  Once the start index is beyond the endpoint, it returns
--the accumulator - that is, the accumulated list of the start positions of all
--"even kernels."
getEvenKernels :: Int -> Int -> [Char] -> [Int] -> [Int]
getEvenKernels s e chs acc
  | s > e = acc 
  | isEvenKernel s chs = getEvenKernels (s+1) e chs (s:acc)
  | otherwise = getEvenKernels (s+1) e chs acc

--getOddKernels is the implementation of allOddKernels.  Takes a start and an
--end position, an input string and an accumulator.  For each index that is the
--start of an "odd kernel" (that is, the potential center of an odd-length
--palindrome - i.e. a triple of the pattern xyx) it adds it to the accumulator.
--Once the start index is beyond the endpoint, it returns the accumulator -
--that is, the accumulated list of start positions of "odd kernels."
getOddKernels :: Int -> Int -> [Char] -> [Int] -> [Int]
getOddKernels s e chs acc
  | s > e = acc 
  | isOddKernel s chs = getOddKernels (s+1) e chs (s:acc)
  | otherwise = getOddKernels (s+1) e chs acc

--allOddKernels is a helper function for allPalindromes.  It iterates over a
--string and returns the start index of any triple of characters where the
--first and last members are identical, since this is the potential center of
--an odd-length palindrome.
allOddKernels :: [Char] -> [Int]
allOddKernels chs = 
  let 
    start = 0
    end = (length chs) - 3
  in
    getOddKernels start end chs []

--allEvenKernels is a helper function for allPalindromes.  It iterates over a
--string and returns the start index of any pair of adjacent, identical
--characters.
allEvenKernels :: [Char] -> [Int]
allEvenKernels chs = 
  let 
    start = 0
    end = (length chs) - 2
  in
    getEvenKernels start end chs []

--expandPalindrome is a helper function for allPalindromes.  It takes an input
--string and a pair of indices representing a palindrome "kernel" and expands
--the pair of indices as far as it can while the expansion continues to
--represent a palindrome.  The expansion adds one to the right index and
--substracts one from the left index and checks whether the characters at the
--new indices are equal.  If they are, this is a legitimate expansion -
--recurse.  If not, it's not, so return the original pair.
expandPalindrome :: [Char] -> (Int,Int) -> (Int,Int)
expandPalindrome chs (a,b)
  | a == 0 = (a,b)
  | b == (length chs) - 1 = (a,b)
  | chs !! (a-1) == chs !! (b+1) = expandPalindrome chs (a-1,b+1)
  | otherwise = (a,b)

--allPalindromes takes a string and generates a list of tuples representing the
--start and end indices of all palindromes in the string.  It does this by
--first finding all the "even Kernels" (that is, pairs of identical characters
--side-by-side, since these represent the potential center of an even-length
--palindrome) and all the "odd Kernels" (that is, sequences of characters of
--the pattern xyx, since these represent the potential center of an odd-length
--palindrome) and then expanding each of them as far as they will go.  It
--returns the concatenation of the expansions of all the even kernels and all
--the odd kernels.
allPalindromes :: [Char] -> [(Int,Int)]
allPalindromes input = 
  let
    evens = [(i,i+1) | i <- allEvenKernels input]
    odds = [(j,j+2) | j <- allOddKernels input]
    expand = expandPalindrome input
  in
    (map expand evens) ++ (map expand odds)

--maximumPair takes a list of integer tuples, a current candidate tuple, and a
--current maximum length, and it iterates over the list of tuples until it
--finds the one representing the longest length.  This is the implementation
--function for maxPair.
maximumPair :: [(Int,Int)] -> (Int,Int) -> Int -> (Int,Int)
maximumPair ((i,j):xs) cand l
  | (length xs) == 0 && j - i > l = (i,j)
  | (length xs) == 0 = cand
  | j - i > l = maximumPair xs (i,j) (j-i)
  | otherwise = maximumPair xs cand l
    
--maxPair takes a list of pairs of indices and returns the pair spanning the
--most distance.  When given an empty list, returns (0,-1) (since this will
--result in returning the empty string when passed to the main function).
maxPair :: [(Int,Int)] -> (Int,Int)
maxPair ((i,j):iss) = maximumPair ((i,j):iss) (i,j) (j-i)
maxPair [] = (0,-1)

--maximumPalindrome takes a string and returns the substring that corresponds
--to the longest palindrome if it exists; "" otherwise.  It does this by first
--generating a list of pairs of indices of every substring in the string that
--is a palindrome. Then, it subtracts the first member of each pair from the
--second to find the longest one. Using the indices representing the
--longest-length palindrome, it pulls that substring out of the original
--string.
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

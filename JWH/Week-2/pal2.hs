--isEvenKernel takes an index and a string and returns True if this index
--points to the first of two adjacent identical characters, False otherwise.
isEvenKernel :: Int -> [Char] -> Bool
isEvenKernel a chs = chs !! a == chs !! (a+1)

--isOddKernel takes a index and a string and returns True if this index points
--to the first of a triple of characters where the first and last are
--identical, False otherwise.
isOddKernel :: Int -> [Char] -> Bool 
isOddKernel a chs = chs !! a == chs !! (a+2)

--expandPalindrome is a helper function for maxpal.  It takes an input
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

--maxpal is the implementation function for maximumPalindrome.  It takes a
--string, an integer representing the current position in the string, the
--position at which it should stop (which is 2 from the end) and the current
--index pair of the candidate for the longest palindrome substring.  It does
--this by first checking whether the current position represents a "kernel" -
--which is the center 2 or 3 characters of a palindrome.  If the current
--position is beyond the stop position, we're done - return the current
--candidate.  If the current position is a kernel, expand the palindrome as far
--as it will go and, if it is longer than the current candidate, advance the
--current position by one and recur with the new index pair.  If it's not
--longer, or if the current position is not a kernel, advance the current
--position by one and recur with the current index pair.
maxpal :: [Char] -> Int -> Int -> (Int,Int) -> (Int,Int)
maxpal chs pos stop (i,j)
  | pos > stop = (i,j)
  | isEvenKernel pos chs && isOddKernel pos chs = maxpal chs (pos+1) stop (maxPair [(i,j), expandPalindrome chs (pos,pos+1), expandPalindrome chs (pos,pos+2)])
  | isEvenKernel pos chs = maxpal chs (pos+1) stop (maxPair [(i,j),expandPalindrome chs (pos,pos+1)])
  | isOddKernel pos chs = maxpal chs (pos+1) stop (maxPair [(i,j),expandPalindrome chs (pos,pos+2)])
  | otherwise = maxpal chs (pos+1) stop (i,j)

--maximumPalindrome takes a string and returns the substring that corresponds
--to the longest palindrome if it exists; "" otherwise.  It does this by
--iterating over the string for every position from the start to a point 2
--characters from the end.  At each point, it determines whether the current
--position represents the start of a "kernel" palindrome, where a kernel is
--either two of the same character in a row (an "even" kernel) or the same two
--characters separated by another character - i.e. a pattern of type xyx (an
--"odd" kernel).  If the current position is the kernel of a palindrome, it
--extends the start and end indices by one and checks whether the two
--characters at the new indices are the same.  If they are, it's still a
--palindrome, so keep going until this condition is no longer true (or until we
--run off the ends of the string).  If this new palindrome is longer than any
--seen so far, replace the current candidate with this one, advance the current
--position by one and recur.  If it is not longer (or if the current position
--is not a kernel), advance the current position by one and keep looking with
--the current candidate.  When the current position is past the stop point,
--return the current candidate.  This algorithm is implemented by the helper
--function maxpal.
maximumPalindrome :: [Char] -> [Char]
maximumPalindrome input = 
  let 
    (i,j) = maxpal input 0 ((length input) - 3) (0,-1)
  in
    take (j-i+1) . drop i $ input

--data type for tests - returns either Passed or Failed.  When failed, includes
--the input it failed on
data Result = Passed | Failed [Char]
  deriving Show

--runTest takes a pair of strings - the first is an input, the second is an
--expected output - and returns a Result.  The Result will be Passed if
--maximumPalindrome run on the first string in the pair returns the expected
--output.  Otherwise, it will be Failed with the failed input included (as per
--the type definition).
runTest :: ([Char],[Char]) -> Result
runTest (input,output)
  | maximumPalindrome input == output = Passed
  | otherwise = Failed input

--runSuite runs runTest over a list of test pairs
runSuite :: [([Char],[Char])] -> [Result]
runSuite = map runTest

main = mapM (\x -> print x) $ runSuite [
            ("abbbb", "bbbb")
          , ("abbbbac", "abbbba")
          , ("aabbbbac", "abbbba")
          , ("aabcdef", "aa")
          , ("aaabcdef", "aaa")
          , ("aaabcdefghiihg", "ghiihg")
          , ("cbbd", "bb")
          , ("bb", "bb")
          , ("bab", "bab")
          , ("bbb", "bbb")
          , ("bbbb", "bbbb")
          , ("baba", "bab")
          , ("caba", "aba")
          , ("abcdefg", "")
        ]

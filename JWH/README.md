# Joshua Herring

These are the solutions for WFCGSG2EB problems by Joshua Herring

## How to Run

All solutions are in Haskell.  You will need a Haskell compiler installed to run them.  The solutions given were compiled with GHC version 8.10.7. 

## Manifest

1. *Week 1 - 2022-09-16 - 4sum*: 
    1. `sum4-bf.hs` - early, brute force solution.  Generates all subsets of the input list, filters out all those that are not length 4, then, from the remaining sets, filters out all the ones that do not sum to the target number. This solution only really works for lists of 27 numbers or fewer.
    1. `sum4-imp.hs` - improved solution.  This generates an ordered list of indices representing all length 4 subsets of the input set, builds all the length 4 subsets using these indices and then filters out the ones that do not sum to the target number.  Due to Haskell's lazy evaluation, this appears to handle lists of any length, even though there is still some room for improvement.  Generating the lists of indices eliminates the main bottleneck of the brute force solution - which was generating all subsets (of any length) only to have to throw most of them away.  It is probably possible to improve on this solution by generating the actual length-4 lists in place (instead of first generating the indices to use and then building the lists based on this list of indices).
1. *Week 2 - 2022-09-23 - Longest Palindrome Substring*: 
    1. `pal.hs` - first iterates over a string finding the indices of all "kernels" of length 2 and length 3, where a "kernel" is a potential palindrome.  A length-2 kernel would be the center of an even-length palindrome (i.e. xx) , and a length-3 kernel would be the center of an odd-length palindrome (i.e. xyx).  Then, for each "kernel," attempts to expand the indices as far as they will go - i.e. it adds one to the right index and subtracts one from the left index as long as the two characters indicated by the new indices are equal (or until one or the other index falls off the end of the string).  Having thus assembled a list of the indices of all palindrome substrings, it finds the pair of indices of maximum length and returns the substring at those positions, since that is the longest palindrome substring.  In the case where there are no palindromes in the string, returns "".
    1. `pal2.hs` - cleans up `pal.hs` and makes it more efficient by keeping track of the longest palindrome substring as it iterates over the input string.  Rather than building a list of all indices of palindrome substrings and retaining the longest from that list, it expands the palindrome for each kernel it finds in place and retains the longest one currently seen through to the end of the string.
1. *Week 3 - 2022-09-30 - Unique Binary Search Trees II*: solution pending
    1. `bintree.hs` - currently a WIP while I figure out how to represent binary trees as arrays

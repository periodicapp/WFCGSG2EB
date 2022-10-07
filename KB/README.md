Solutions for WFCGSG2EB problems by Karthik Bangera

## Manifest

1. *Week1 - 2022-09-16 - 4sum*: 
    1. `4sum.py` - Uses the itertools module in python to generates all subsets of the input list. Python sets are used to remove any duplicates
1. *Week 2 - 2022-09-23 - Longest Palindrome Substring*: 
    1. `palindrome.go` - The solution loops through till the middle of the given string and during the loop it expands to search individual sub strings.
    It keeps track of indices of the longest palindromic substring and upon reaching the loop exit condition returns the longest palindromic substring using the 
    tracked indices
1. *Week 3 - 2022-09-30 - Inorder traversal of binary search tree*: 
    1. `inorderbst.go` - Builds the binary search tree from the input and uses recursion to traverse the BST inorder i.e left root right
1. *Week 4 - 2022-10-07 - Determine if a 9 x 9 Sudoku board is valid or not*: 
    1. `validsudoku.go` - Traverses 9 rows, 9 columns and the individual 3x3 grid. Each traversal builds a bool array that keeps track of, if the number has been
    seen or not during the traversal. If there is a repetition return false else return true
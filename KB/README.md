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
1. *Week 5 - 2022-10-14 - Best time to buy and sell stock*:
    1. `stock_easy.go` - Setup a minPrice anchor and initialize it to the 0th item in the prices array to begin with. Traverse through the values in the array and 
    compare it first with the current value of the minPrice anchor. if it is less than the minPrice anchor, set the new value you found to the minPrice anchor and proceed to 
    the next item in the array. If not, find the difference between the current value in the array traversal to the value in the minPrice anchor. Set the difference between
    them to a tmpProfit variable. If the tmpProfit is greater than the current maxProfit. Set the tmpProfit as the new maxProfit and continue till the end of the prices array
    is reached
    1. `stock_medium.go` - Start with index=1 of the prices array and compare value at index and index-1. If the value at index is greater than value at index - 1. 
    Find the difference between them and set the profit variable to the difference value else proceed to the next index and perform the index to index-1 comparison.
    Upon reaching the end of the prices array the profit variable should have the maximum profit you can achieve
# Austin Parks

These are the solutions for WFCGSG2EB problems by Austin Parks

## How to Run

All solutions in Python.
As of 09/2022 solutions were created in [Python 3.10.1](https://www.python.org/downloads/release/python-3101/)

## Manifest

1. *[Week1.py](Week1.py) - 2022-09-16 - [4sum](https://leetcode.com/problems/4sum/)*
   1. Contains solutions to [2sum](https://leetcode.com/problems/two-sum/), [3sum](https://leetcode.com/problems/3sum/) and [4sum/ksum](https://leetcode.com/problems/4sum/)
      1. [2sum](https://leetcode.com/problems/two-sum/) is implemented utilizing a dictionary, and a simple for-loop returning indexes of combinations.
      2. [3sum](https://leetcode.com/problems/3sum/) is implemented utilizing a 2 pointer system on a sorted list with varying conditions for incrementing and decrementing based on the sum of the current pointers
      3. [4sum](https://leetcode.com/problems/4sum/) utilizes a combination of 3sum and 2sum to make a solution that can be utilized against any length of requested combinations. Here it is used to make a 4sum combo, but could also be utilized to make a 5sum, 6sum, 7sum, etc... It is implemented with a naturally recursive function ksum that passes to the 2sum helper.
2. *[Week2.py](Week2.py) - 2022-09-23 - [Longest Palindrome](https://leetcode.com/problems/longest-palindromic-substring/solution/)*
   1. Contains 2 solutions to [Longest Palindrome](https://leetcode.com/problems/longest-palindromic-substring/solution/)
      1. Brute Force Algorithm
      2. LeetCode's "Dynamic Programming" Algorithm
3. *[Week3.py](Week3.py) - 2022-09-30 - [Unique Binary Search Trees](https://leetcode.com/problems/unique-binary-search-trees-ii)*
   1. 1.5 solutions to [Unique Binary Search Trees](https://leetcode.com/problems/unique-binary-search-trees-ii)
      1. generateTreesNonUnique: Generates lists of every possible combination of a range from (1, ..., n) then builds binary trees for all of them, but some trees are non-unique. Mostly just included this one for the recursive combinations helper I created.
      2. generateTrees: Contains a recursive helper that generates structurally-unique trees from the given start and end ranges.
   2. 2 Solutions to [In-Order BST Traversing](https://leetcode.com/problems/binary-tree-inorder-traversal/)
      1. inorderTraversalRecur: Standard recursive way of traversing a BST in order from left to right
      2. inorderTraversal: Non-Recursive implementation utilizing the [Morris Traversal Algorithm](https://www.educative.io/answers/what-is-morris-traversalter)
4. *[Week4.py](Week4.py) - 2022-10-07 - [Sudoku](https://leetcode.com/problems/sudoku-solver)*
   1. 2 Solutions for the Easy Leetcode Problem: [Every Column has Every Number](https://leetcode.com/problems/check-if-every-row-and-column-contains-all-numbers/)
   2. 1 Solution for the Medium Problem: [Valid Sudoku](https://leetcode.com/problems/valid-sudoku/)
   3. 1 somewhat incomplete solution for Hard Problem: [Sudoku Solver](https://leetcode.com/problems/sudoku-solver)
5. *[Week5.py](Week5.py) - 2022-10-14 - Stonks*
   1. 1 solution to [Best Time to Buy and Sell Stock](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/) (**EASY**)
   2. 1 solution to [Best Time to Buy and Sell Stock II](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-ii/) (**MEDIUM**)
   3. 2 solutions to [Best Time to Buy and Sell Stock III](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-iii/) (**HARD**)
6. *[Week7.py](Week7.py) - 2022-11-04 - Encode/Decode*
   1. 1 solution to [Binary Watch](https://leetcode.com/problems/binary-watch/) (**EASY**)
   2. 1 solution to [Decode Ways](https://leetcode.com/problems/decode-ways/) (**MEDIUM**)
   3. 2 solutions to [Decode Ways II](https://leetcode.com/problems/decode-ways-ii/) (**HARD**)
      1. First solution decodeWaysH uses too much memory for LeetCode
      2. Second solution decodeWaysQueue utilizes a 3 sized queue to solve the memory issues

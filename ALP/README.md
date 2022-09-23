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

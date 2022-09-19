# Austin Parks

These are the solutions for WFCGSG2EB problems by Austin Parks

## How to Run

All solutions in Python.
As of 09/2022 solutions were created in Python 3.10.1

## Manifest

1. *Week 1 - 2022-09-16 - 4sum*:
   1. Contains solutions to 2sum, 3sum and 4sum/ksum.
      1. 2sum is implemented utilizing a dictionary, and a simple for-loop returning indexes of combinations.
      2. 3sum is implemented utilizing a 2 pointer system on a sorted list with varying conditions for incrementing and decrementing based on the sum of the current pointers
      3. 4sum utilizes a combination of 3sum and 2sum to make a solution that can be utilized against any length of requested combinations. Here it is used to make a 4sum combo, but could also be utilized to make a 5sum, 6sum, 7sum, etc... It is implemented with a naturally recursive function ksum that passes to the 2sum helper.

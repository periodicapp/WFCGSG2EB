# Joshua Herring

These are the solutions for WFCGSG2EB problems by Joshua Herring

## How to Run

All solutions are in Haskell.  You will need a Haskell compiler installed to run them.  The solutions given were compiled with GHC version 8.10.7. 

## Manifest

1. *Week 1 - 2022-09-16 - 4sum*: 
    1. `sum4-bf.hs` - early, brute force solution.  Generates all subsets of the input list, filters out all those that are not length 4, then, from the remaining sets, filters out all the ones that do not sum to the target number. This solution only really works for lists of 27 numbers or fewer.
    1. `sum4-imp.hs` - improved solution.  This generates an ordered list of indices representing all length 4 subsets of the input set, builds all the length 4 subsets using these indices and then filters out the ones that do not sum to the target number.  Due to Haskell's lazy evaluation, this appears to handle lists of any length, even though there is still some room for improvement.  Generating the lists of indices eliminates the main bottleneck of the brute force solution - which was generating all subsets (of any length) only to have to throw most of them away.  It is probably possible to improve on this solution by generating the actual length-4 lists in place (instead of first generating the indices to use and then building the lists based on this list of indices).

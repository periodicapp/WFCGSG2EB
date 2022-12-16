package main

import (
	"fmt"
)

/*
   1. Create two arrays with the same length as the given array.
       1a. One will represent the left-side maximum values at each index
       1b. One will represent the right-side maximum values at each index
   2. Iterate through the given array and reference the index in the created arrays
       2a. Find the min() of the two maxes (left and right) and subtract the height at the index
       2b. Add that value to the total water
*/

func main() {
	ex1 := []int{
		0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1,
	}
	ex2 := []int{
		4, 2, 0, 3, 2, 5,
	}
	ex3 := []int{
		4, 2, 3,
	}
	fmt.Println("------------------------")
	fmt.Println("| Trapping Rainwater I |")
	fmt.Println("------------------------")
	fmt.Printf("trap([0,1,0,2,1,0,1,3,2,1,2,1]) - expect: 6 :: got: %d\n\n", trap(ex1))
	fmt.Printf("trap([4,2,0,3,2,5]) - expect: 9 :: got: %d\n\n", trap(ex2))
	fmt.Printf("trap([4,2,3]) - expect: 1 :: got: %d\n\n", trap(ex3))
}

func trap(height []int) int {
	debug := false
	water, leftMax, rightMax := 0, 0, 0
	lefts := make([]int, len(height))
	rights := make([]int, len(height))

	for i := 0; i < len(height); i++ {
		if height[i] > leftMax {
			leftMax = height[i]
		}

		lefts[i] = leftMax
	}

	for i := len(height) - 1; i >= 0; i-- {
		if height[i] > rightMax {
			rightMax = height[i]
		}
		rights[i] = rightMax
	}

	for i, n := range height {
		if debug {
			fmt.Println("Heights: ", height)
			fmt.Printf("LeftMax: %d, RightMax: %d - Min: %d\n", lefts[i], rights[i], min(lefts[i], rights[i]))
			fmt.Println("current element:", n)
			fmt.Println("water added:", min(lefts[i], rights[i])-n)
			fmt.Println()
		}
		water += min(lefts[i], rights[i]) - n
	}

	return water
}

func min(arg1, arg2 int) int {
	if arg1 <= arg2 {
		return arg1
	} else {
		return arg2
	}
}

func max(arg1, arg2 int) int {
	if arg1 >= arg2 {
		return arg1
	} else {
		return arg2
	}
}
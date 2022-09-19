package main

import "fmt"

// Given an array nums of n integers, return an array of all the unique quadruplets [nums[a], nums[b], nums[c], nums[d]] such that:

//     0 <= a, b, c, d < n
//     a, b, c, and d are distinct.
//     nums[a] + nums[b] + nums[c] + nums[d] == target

// You may return the answer in any order.

// Example 1:

// Input: nums = [1,0,-1,0,-2,2], target = 0
// Sorted: nums = [-2, -1, 0, 0, 1, 2]
// Output: [[-2,-1,1,2],[-2,0,0,2],[-1,0,0,1]]

// Example 2:

// Input: nums = [2,2,2,2,2], target = 8
// Output: [[2,2,2,2]]

var nums = []int{1, 0, -1, 0, -2, 2}

const target = 0

var indexSumMap = make(map[int][][]int, 0) // Map of sum v array of arrays of index pairs

var finalIndexTupleArray = make([][]int, 0)

func main() {

	// Populate index
	// Create a 2D array of sums or a map

	for i := 0; i < len(nums); i++ {
		for j := 0; j < len(nums); j++ {
			// Ignore pairs where i == j
			if i == j {
				continue
			}

			// Add sum to indexSumMap
			sum := nums[i] + nums[j]
			indexArr := make([]int, 0)
			indexArr = append(indexArr, i, j)                     // Create [i,j]
			indexSumMap[sum] = append(indexSumMap[sum], indexArr) // Create indexSumMap[someSum] = [[i,j],[i2,j2],etc...]
		}
	}

	// Debug: Print the indexSumMap
	// for k, v := range indexSumMap {
	// 	fmt.Print("Sum: ", k, " indexTuples: ")
	// 	for _, indexTuple := range v {
	// 		fmt.Print(indexTuple, " ")
	// 	}
	// 	fmt.Println()
	// }
	// Debug end

	for _, indexTupleArray := range indexSumMap {
		for _, indexTuple := range indexTupleArray {
			remainderIndexTuple := findPairWithRemainder(indexTuple)
			// Debug: check the remainder pairs
			// fmt.Print("Sum: ", sum, " Index tuple", indexTuple, "\n")
			// fmt.Println("Remainder tuple array: ", remainderIndexTuple)
			// Debug end

			// Create a four element pairs based on the following rules
			// Go through the tuple array to check the following
			// a. The result of the sum of both pairs is the target.
			// b. The resulting 4-element array is not in the final array already (elements may be in any order).
			// c. An index is not included twice in the 4-element array (reason why I switched from storing the values to storing the index)

			for _, remainderIndexTuple := range remainderIndexTuple {
				// Check if any indexes are being repeated, skip the remainderIndexTuple if they do
				checkIndexDups := hasIndexDups(indexTuple, remainderIndexTuple)
				if checkIndexDups {
					continue
				}

				// Check sum and add values to final map
				checkSum := checkSum_AddToFinalMap(indexTuple, remainderIndexTuple)
				if !checkSum {
					continue
				}

			}
		}
		// break // Debug statement
	}

	// Print final array
	fmt.Printf("Final index tuple array: %+v\n", finalIndexTupleArray)

}

func checkSum_AddToFinalMap(orig []int, remainder []int) bool {
	var sum int
	fourElemTuple := append(orig, remainder...)
	for _, index := range fourElemTuple {
		sum += nums[index]
	}

	// Sanity check to make sure sum == target
	if sum != target {
		return false
	}

	fourElemIndexTuple := append(orig, remainder...)
	// Debug: Check with 4-element tupleis being skipped
	// fmt.Println("Tuple to be checked: ", fourElemIndexTuple)
	// Debug end
	fourElemIndexDup := has4ElementIndexDups(fourElemIndexTuple)
	if fourElemIndexDup {
		return false
	}

	finalIndexTupleArray = append(finalIndexTupleArray, fourElemIndexTuple)

	return true

}

func has4ElementIndexDups(orig []int) bool {
	for _, finalIndexTuple := range finalIndexTupleArray {
		var tempMap = make(map[int]bool, 0)
		for _, finalIndex := range finalIndexTuple {
			tempMap[finalIndex] = true
		}
		beforeLen := len(tempMap)
		for _, origIndex := range orig {
			tempMap[origIndex] = true
		}
		afterLen := len(tempMap)

		if beforeLen == afterLen {
			return true
		}
	}

	return false
}

func hasIndexDups(orig []int, remainder []int) bool {
	for _, origIndex := range orig {
		for _, remIndex := range remainder {
			if origIndex == remIndex {
				return true
			}
		}
	}

	return false
}

func findPairWithRemainder(orig []int) [][]int {
	var currentSum int

	for _, indexVal := range orig {
		currentSum += nums[indexVal]
	}

	remainder := target - currentSum

	// Find pair in indexTupleArray under the remainder key

	indexTupleArray := indexSumMap[remainder]

	return indexTupleArray

}

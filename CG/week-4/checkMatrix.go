package main

import(
	"fmt"
)

// https://leetcode.com/problems/check-if-every-row-and-column-contains-all-numbers/
func main() {
	test1 := [][]int{
		{1, 2, 3},
		{2, 3, 1},
		{3, 1, 2},
	}
	test2 := [][]int{
		{2, 2, 2},
		{2, 2, 2},
		{2, 2, 2},
	}
	test3 := [][]int{
		{1, 2, 3, 4, 5},
		{2, 3, 5, 1, 4},
		{3, 4, 1, 5, 2},
		{4, 5, 2, 3, 1},
		{5, 1, 4, 2, 3},
	}
	test4 := [][]int{
		{1, 2, 3, 4, 5},
		{2, 3, 5, 1, 4},
		{3, 5, 5, 5, 2},
		{4, 5, 2, 3, 1},
		{5, 1, 4, 2, 3},
	}

	fmt.Println()
	fmt.Println("########################")
	fmt.Println("## CHECK VALID MATRIX ##")
	fmt.Println("########################")
	fmt.Println("[[1, 2, 3], [2, 3, 1], [3, 1, 2]] - ", checkValid(test1))
	fmt.Println("[[2, 2, 2], [2, 2, 2], [2, 2, 2]] - ", checkValid(test2))
	fmt.Println("[[1, 2, 3, 4, 5], [2, 3, 5, 1, 4], [3, 4, 1, 5, 2], [4, 5, 2, 3, 1], [5, 1, 4, 2, 3]] - ", checkValid(test3))
	fmt.Println("[[1, 2, 3, 4, 5], [2, 3, 5, 1, 4], [3, 5, 5, 5, 2], [4, 5, 2, 3, 1], [5, 1, 4, 2, 3]] - ", checkValid(test4))
	fmt.Println()
}

func checkValid(matrix [][]int) bool {
	// Loop through rows
	for i, row := range matrix {
			// Check that the row passes, fail if not
			rowPass := checkRowOrCol(row)
			if !rowPass {
					return false
			}
			col := make([]int, 0)
			// Construct a column
			for j, _ := range row {
					col = append(col, matrix[j][i])
			}
			// Check that the column passes, fail if not
			colPass := checkRowOrCol(col)
			if !colPass {
					return false
			}
	}
	return true
}

// A row or column will return true if each of its elements is unique
func checkRowOrCol(rowOrCol []int) bool {
	itemMap := make(map[int]bool)
	for _, n := range rowOrCol {
			itemMap[n] = true
	}
	return len(rowOrCol) == len(itemMap)
}

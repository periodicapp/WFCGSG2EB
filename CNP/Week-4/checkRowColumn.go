package main

import "fmt"

// Input: matrix = [[1,2,3],[3,1,2],[2,3,1]]

func main() {
	inputMatrix := [][]int{
		{1, 2, 3}, {3, 1, 2}, {2, 3, 1},
	}

	fmt.Println(checkValid(inputMatrix))
}
func checkValid(matrix [][]int) bool {
	matrixLen := len(matrix)
	for i := 0; i < matrixLen; i++ {
		tempMap := make(map[int]int)
		tempMap1 := make(map[int]int)
		for j := 0; j < matrixLen; j++ {
			tempMap[matrix[i][j]]++
			tempMap1[matrix[j][i]]++
		}
		if len(tempMap) != matrixLen || len(tempMap1) != matrixLen {
			return false
		}
	}
	return true
}

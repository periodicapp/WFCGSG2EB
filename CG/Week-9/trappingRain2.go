func trapRainWater(heightMap [][]int) int {

	totalWater := 0

	// Make a new collection of arrays.  If what's given is "rows" this would be "cols"
	cols := make([][]int, 0)
	for i := 0; i < len(heightMap[0]); i++ {
		col := make([]int, len(heightMap))
		maxIndexForCol := len(heightMap) - 1
		for j := maxIndexForCol; j >= 0; j-- {
			col[maxIndexForCol-j] = heightMap[j][i]
		}
		cols = append(cols, col)
	}

	// Build matrix that represents the water height in the grid when running trap on all the rows
	// Build matrix that represents the water height in the grid when running trap on all the cols
	matrixByRow := make([][]int, 0)
	matrixByCol := make([][]int, 0)

	for _, a := range heightMap {
		matrixByRow = append(matrixByRow, trap(a))
	}
	for _, a := range cols {
		matrixByCol = append(matrixByCol, trap(a))
	}
	fmt.Println("BEFORE ROTATE", matrixByCol)
	// "rotate" the matrixByCol so it can be easily compared with the other matrix
	matrixByCol = rotate(matrixByCol)

	fmt.Println("MATRIX 1", matrixByRow)
	fmt.Println("MATRIX 2", matrixByCol)

	// Compare the matrices and save the min of the calculated water at each spot
	for i := 0; i < len(heightMap); i++ {
		for j := 0; j < len(heightMap[0]); j++ {
			totalWater += min(matrixByRow[i][j], matrixByCol[i][j])
		}
	}

	return totalWater
}

func trap(height []int) []int {
	waterArray := make([]int, len(height))
	debug := false
	leftMax, rightMax := 0, 0
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
		waterArray[i] = min(lefts[i], rights[i]) - n
	}

	return waterArray
}

func rotate(matrix [][]int) [][]int {
	rotated := make([][]int, 0)

	for i := len(matrix[0]) - 1; i >= 0; i-- {
		newArr := make([]int, len(matrix))
		for j := 0; j < len(matrix); j++ {
			newArr[j] = matrix[j][i]
		}
		rotated = append(rotated, newArr)
	}

	return rotated
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

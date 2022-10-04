package main

import(
	"fmt"
)

// https://leetcode.com/problems/valid-sudoku/
/*
	#### LEETCODE RESULTS ####
	Runtime: 8 ms, faster than 32.97% of Go online submissions for Valid Sudoku.
	Memory Usage: 2.7 MB, less than 63.17% of Go online submissions for Valid Sudoku.
*/
func main() {
	// Same as examples from LeetCode
	board1 := [][]byte{
		{'5', '3', '.', '.', '7', '.', '.', '.', '.'},
		{'6', '.', '.', '1', '9', '5', '.', '.', '.'},
		{'.', '9', '8', '.', '.', '.', '.', '6', '.'},
		{'8', '.', '.', '.', '6', '.', '.', '.', '3'},
		{'4', '.', '.', '8', '.', '3', '.', '.', '1'},
		{'7', '.', '.', '.', '2', '.', '.', '.', '6'},
		{'.', '6', '.', '.', '.', '.', '2', '8', '.'},
		{'.', '.', '.', '4', '1', '9', '.', '.', '5'},
		{'.', '.', '.', '.', '8', '.', '.', '.', '9'},
	}

	board2 := [][]byte{
		{'8', '3', '.', '.', '7', '.', '.', '.', '.'},
		{'6', '.', '.', '1', '9', '5', '.', '.', '.'},
		{'.', '9', '8', '.', '.', '.', '.', '6', '.'},
		{'8', '.', '.', '.', '6', '.', '.', '.', '3'},
		{'4', '.', '.', '8', '.', '3', '.', '.', '1'},
		{'7', '.', '.', '.', '2', '.', '.', '.', '6'},
		{'.', '6', '.', '.', '.', '.', '2', '8', '.'},
		{'.', '.', '.', '4', '1', '9', '.', '.', '5'},
		{'.', '.', '.', '.', '8', '.', '.', '.', '9'},
	}

	fmt.Println()
	fmt.Println("########################")
	fmt.Println("## CHECK VALID SUDOKU ##")
	fmt.Println("########################")
	fmt.Println("Board 1 (see code)", isValidSudoku(board1))
	fmt.Println("Board 2 (see code)", isValidSudoku(board2))
	fmt.Println()
}

func isValidSudoku(board [][]byte) bool {
	// Loop through rows
	for i, row := range board {
			// Check the row first
			rowPass := check(row)
			// Fail if the row doesn't pass
			if !rowPass {
					return false
			}
			col := make([]byte, 0)
			// With this loop, build up a column to check && check one subsquare
			for j, _ := range row {
					// Building up the column
					col = append(col, board[j][i])
					// You can tell if you're on a "top-left" position of a subsquare if
					// i and j are both divisible by 3 (or are 0).  If that condition is detected,
					// you can build up a subsquare and check it the same way you'd check a row or col.
					// All 9 subsquares will hit this condition.
					if (i % 3 == 0) && (j % 3 == 0) {
							subsquarePass := checkSubsquare(i, j, board)
							if !subsquarePass {
									return false
							}
					}
			}
			// Fail if the column doesn't pass
			colPass := check(col)
			if !colPass {
					return false
			}
	}
	// If no failure yet, the sudoku is valid
	return true
}

// This func builds up a subsquare given a "top-left" position on a subsquare present on the board
func checkSubsquare(rowSeed, colSeed int, board [][]byte) bool {
	subsquare := make([]byte, 0)
	// Subsquares are always 3x3.  Using the following loops in combination with the row/col passed in,
	// you can grab the elements from the board you need to comprise a subsquare.
	for i := 0; i < 3; i++ {
			for j := 0; j < 3; j++ {
					subsquare = append(subsquare, board[rowSeed + i][colSeed + j])
			}
	}
	return check(subsquare)
}

// This will take an array of byte.  Iterating over the array, a Map will keep track of what's been seen
// already.  If you come across a byte that already exists in the map and isn't ".", then the check
// should fail because you've got a duplicate number in the row, col, or subsquare.
func check(candidate []byte) bool {
	itemMap := make(map[byte]bool)
	var placeholder byte = '.'
	for _, e := range candidate {
			keyok, _ := itemMap[e]
			if keyok && e != placeholder {
					return false
			} else {
					itemMap[e] = true
			}
	}
	return true
}
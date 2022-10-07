// You can edit this code!
// Click here and start typing.
package main

import (
	"fmt"
	"strconv"
)

func isValidSudoku(board [][]string) bool {
	for row := 0; row < 9; row++ {
		if !checkrow(board, row) {
			return false
		}
	}
	for column := 0; column < 9; column++ {
		if !checkcolumn(board, column) {
			return false
		}
	}
	for grid := 0; grid < 9; grid++ {
		if !checkgrid(board, grid) {
			return false
		}
	}
	return true
}

func checkrow(board [][]string, row int) bool {
	var rowBoolArray [10]bool
	for i := 0; i < 9; i++ {
		boardItemConverted := convertToNumber(board[row][i])
		if boardItemConverted < 0 {
			continue
		}
		if rowBoolArray[boardItemConverted] == true {
			return false
		}
		rowBoolArray[boardItemConverted] = true

	}
	//fmt.Println(rowBoolArray)
	return true

}
func checkcolumn(board [][]string, column int) bool {
	var columnBoolArray [10]bool
	for i := 0; i < 9; i++ {
		boardItemConverted := convertToNumber(board[i][column])
		if boardItemConverted < 0 {
			continue
		}
		if columnBoolArray[boardItemConverted] == true {
			return false
		}
		columnBoolArray[boardItemConverted] = true

	}
	return true

}

func checkgrid(board [][]string, grid int) bool {
	var gridBoolArray [10]bool
	row := (grid / 3) * 3
	column := (grid % 3) * 3
	for i := 0; i < 3; i++ {
		for j := 0; j < 3; j++ {
			boardItemConverted := convertToNumber(board[row+i][column+j])
			if boardItemConverted < 0 {
				continue
			}
			if gridBoolArray[boardItemConverted] == true {
				return false
			}
			gridBoolArray[boardItemConverted] = true
		}

	}
	return true

}

func convertToNumber(boardItem string) int {
	if boardItem == "." {
		return -1
	} else {
		number, _ := strconv.Atoi(boardItem)
		return number
	}

}

func main() {
	board := [][]string{
		{"5", "4", ".", ".", "7", ".", ".", ".", "."},
		{"6", ".", ".", "1", "9", "5", ".", ".", "."},
		{".", "9", "8", ".", ".", ".", ".", "6", "."},
		{"8", ".", ".", ".", "6", ".", ".", ".", "3"},
		{"4", ".", ".", "8", ".", "3", ".", ".", "1"},
		{"7", ".", ".", ".", "2", ".", ".", ".", "6"},
		{".", "6", ".", ".", ".", ".", "2", "8", "."},
		{".", ".", ".", "4", "1", "9", ".", ".", "5"},
		{".", ".", ".", ".", "8", ".", ".", "7", "9"},
	}
	fmt.Println(isValidSudoku(board))
}

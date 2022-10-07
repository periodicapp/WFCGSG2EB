package main

import(
	"fmt"
)

var fillMap = map[byte]bool{
    '1': true,
    '2': true,
    '3': true,
    '4': true,
    '5': true,
    '6': true,
    '7': true,
    '8': true,
    '9': true,
}
var placeholder byte = '.'
var possibilitiesMap = make(map[[2]int][]byte)

func solveSudoku(board [][]byte)  {
		// Find all possiblities for each empty space. Stick them in a map like:
		// [0, 2] = [1, 2, 4]
		// ...
    possibilitiesMap = generateAllPossibilities(board)
		
}

// Traverse the board and find all the possiblities for each empty space
func generateAllPossibilities(board [][]byte) map[[2]int][]byte {
    returnMap := make(map[[2]int][]byte)
    for i, row := range board {
        for j, _ := range row {
            if board[i][j] == placeholder {
                key := [2]int{i, j}
                returnMap[key] = getPossibilitiesForSpace(board, i, j)
            }
        }
    }
    return returnMap
}

// This finds what's missing from the row, col, and subsquare, and returns
// the common values over all those arrays.  This leaves you with the only valid 
// responses for a given space.
func getPossibilitiesForSpace(board [][]byte, row, col int) []byte {
    missingFromRow := getMissing(board[row])
    missingFromCol := getMissing(getCol(board, col))
    missingFromSq := getMissing(getSquare(board, row, col))
    return getIntersection(missingFromRow, missingFromCol, missingFromSq)
}

// Given a []byte, find the nums that are missing (1-9)
func getMissing(list []byte) []byte {
    fillMapCopy := make(map[byte]bool)
    missing := make([]byte, 0)
    for k, _ := range fillMap {
        fillMapCopy[k] = fillMap[k]
    }
    for _, el := range list {
        fillMapCopy[el] = false
    }
    for k, v := range fillMapCopy {
        if v {
            missing = append(missing, k)
        }
    }
    return missing
}

// Given a board and a column index, return an []byte of the nums in the column
func getCol(board [][]byte, col int) []byte {
    column := make([]byte, 0)
    for i := 0; i < 9; i++ {
        column = append(column, board[i][col])
    }
    return column
}

// Given a board and a row/col, get the values for the current subsquare in an []byte
func getSquare(board [][]byte, row, col int) []byte {
    for row % 3 != 0 {
        row--
    }
    for col % 3 != 0 {
        col--
    }
    subsquare := make([]byte, 0)
    for i := 0; i < 3; i++ {
        for j := 0; j < 3; j++ {
            subsquare = append(subsquare, board[row + i][col + j])
        }
    }
    return subsquare
}

// Takes 3 arrays and returns one that is the intersection of all of them
func getIntersection(row, col, sq []byte) []byte {
    trackMap := make(map[byte]int)
    intersection := make([]byte, 0)
    for _, rowEl := range row {
        trackMap[rowEl] = trackMap[rowEl] + 1
    }
    for _, colEl := range col {
        trackMap[colEl] = trackMap[colEl] + 1
    }
    for _, sqEl := range sq {
        trackMap[sqEl] = trackMap[sqEl] + 1
    }
    for k, v := range trackMap {
        if v == 3 {
            intersection = append(intersection, k)
        }
    }
    return intersection
}

///////////////////////////////////////////////////////////////////////
// Here down is the medium puzzle that is used to check valid boards //
///////////////////////////////////////////////////////////////////////

func isValidSudoku(board [][]byte) bool {
    for i, row := range board {
        rowPass := check(row)
        if !rowPass {
            return false
        }
        col := make([]byte, 0)
        for j, _ := range row {
            col = append(col, board[j][i])
            if (i % 3 == 0) && (j % 3 == 0) {
                subsquarePass := checkSubsquare(i, j, board)
                if !subsquarePass {
                    return false
                }
            }
        }
        colPass := check(col)
        if !colPass {
            return false
        }
    }
    return true
}

func checkSubsquare(row, col int, board [][]byte) bool {
    subsquare := make([]byte, 0)
    for i := 0; i < 3; i++ {
        for j := 0; j < 3; j++ {
            subsquare = append(subsquare, board[row + i][col + j])
        }
    }
    return check(subsquare)
}

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

func printBoard(board [][]byte) {
    fmt.Println()
	for _, row := range board {
		for j, _ := range row {
			fmt.Printf(" %s ", string(row[j]))
		}
		fmt.Println()
	}
    fmt.Println()
}
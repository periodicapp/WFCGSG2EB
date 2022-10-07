package main

import(
	"fmt"
)

// This is used in trying to figure out what options are in a row/col/subsquare
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

func main() {
	board1 := [][]byte{
		{'5', '3', '.', '.', '7', '.', '.', '.', '.'},
		{'6', '.', '.', '1', '9', '5', '.', '.', '.'},
		{'.', '9', '8', '.', '.', '.', '.', '6', '.'},
		{'8', '.', '.', '.', '6', '.', '.', '.', '3'},
		{'4', '.', '.', '8', '.', '3', '.', '.', '1'},
		{'7', '.', '.', '.', '2', '.', '.', '.', '6'},
		{'.', '6', '.', '.', '.', '.', '2', '8', '.'},
		{'.', '.', '.', '4', '1', '9', '.', '.', '5'},
		{'.', '.', '.', '.', '8', '.', '.', '7', '9'},
	}

	solveSudoku(board1)
}

func solveSudoku(board [][]byte)  {
		// If the board has empties, keep solving
    for !boardIsSolved(board) {
				// Find all possible options for each space
        possibilitiesMap = generateAllPossibilities(board)
				// Solve spaces that have a single option and do it again
        board = solveSinglePossiblities(board, possibilitiesMap)
        printBoard(board)
    }
}

// Return a map with grid indices mapped to an array of options for that space
func generateAllPossibilities(board [][]byte) map[[2]int][]byte {
    returnMap := make(map[[2]int][]byte)
    for i, row := range board {
        for j, _ := range row {
						// If the space has a blank, then get the possibilities
            if board[i][j] == placeholder {
                key := [2]int{i, j}
                returnMap[key] = getPossibilitiesForSpace(board, i, j)
            }
        }
    }
    return returnMap
}

// Get the possibilities for the relevant row/column/subsquare and return the intersection
func getPossibilitiesForSpace(board [][]byte, row, col int) []byte {
    missingFromRow := getMissing(board[row])
    missingFromCol := getMissing(getCol(board, col))
    missingFromSq := getMissing(getSquare(board, row, col))
    return getIntersection(missingFromRow, missingFromCol, missingFromSq)
}

// Given an array of nums, return an array of bytes with the missing nums (1-9)
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

// Given a board, and a col index, assembly an []byte of the nums in the column
func getCol(board [][]byte, col int) []byte {
    column := make([]byte, 0)
    for i := 0; i < 9; i++ {
        column = append(column, board[i][col])
    }
    return column
}

// Given coordinates, get the nearest subsquare
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

// Given 3 arrays, return the intersection of them
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

// Take a board and a map of possibilities, and solve all the spaces for which there is only 
// one possibility
func solveSinglePossiblities(board [][]byte, possibilities map[[2]int][]byte) [][]byte {
    newBoard := board
    for k, v := range possibilities {
        if len(v) == 1 {
            newBoard[k[0]][k[1]] = v[0]
        }
    }
    return newBoard
}

// If empties exist on the board, return false, otherwise true
func boardIsSolved(board [][]byte) bool {
    for i, row := range board {
        for j, _ := range row {
            if board[i][j] == placeholder {
                return false
            }
        }
    }
    return true
}

// Print out a map that has []byte as the value stringified for easy reading
func printMap(m map[[2]int][]byte) {
    for k, v := range m {
        fmt.Print(k)
        fmt.Print(": ")
        fmt.Println(string(v))
    }
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


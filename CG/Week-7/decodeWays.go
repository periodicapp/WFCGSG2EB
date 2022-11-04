package main

import(
	"fmt"
	"strconv"
)

// This does not work for larger strings of numbers.  It doens't pass the leetcode submission
// I see there's super shorter ways to do this online but i wasn't understanding those.

func main() {
	fmt.Println("numDecodings('12')", numDecodings("12"))
	fmt.Println("numDecodings('06')", numDecodings("06"))
	fmt.Println("numDecodings('226')", numDecodings("226"))
	// fmt.Println("numDecodings('2611055971756562')", numDecodings("2611055971756562"))
	// fmt.Println("numDecodings('71756562')", numDecodings("71756562"))
}

func numDecodings(s string) int {
	allPossibilities := make([][]string, 0)
	current := make([]string, 0)
	startingIndex := 0
	allPossibilities = validate(findAllCombos(allPossibilities, current, startingIndex, s))
	return len(allPossibilities)
}

func findAllCombos(allCombos [][]string, current []string, currentIndex int, source string) [][]string {
	if currentIndex >= len(source) {
			allCombos = append(allCombos, current)
			return allCombos
	} else {
			currentAndOne := append(current, string(source[currentIndex]))
			allCombos = findAllCombos(allCombos, currentAndOne, currentIndex + 1, source)
			if currentIndex + 2 <= len(source) {
				currentAndTwo := append(current, string(source[currentIndex:currentIndex+2]))
				allCombos = findAllCombos(allCombos, currentAndTwo, currentIndex + 2, source)
			}
		return allCombos
	}
}

func validate(combos [][]string) [][]string {
	passingCombos := make([][]string, 0)
	for _, combo := range combos {
			comboFailed := false
			for _, piece := range combo {
					parsed, _ := strconv.ParseInt(piece, 0, 32)
					if string(piece[0]) == "0" {
							comboFailed = true
							continue
					} else if parsed > 26 {
							comboFailed = true
							continue
					}
			}
		if comboFailed {
			continue
		} else {
			passingCombos = append(passingCombos, combo)
		}
	}

	return passingCombos
}
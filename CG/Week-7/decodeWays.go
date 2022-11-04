package main

import(
	"fmt"
	"strconv"
)

// This does not work for larger strings of numbers.  It doens't pass the leetcode submission
// I see there's super shorter ways to do this online but i wasn't understanding those.
// The recusion part is wrong and it doesn't get all the possibilities when the string gets big.  
// I can't really explain how it's meant to work as I was just trying a lot of things to 
// try and get it to work.

func main() {
	fmt.Println("numDecodings('12')", numDecodings("12"))
	fmt.Println("numDecodings('06')", numDecodings("06"))
	fmt.Println("numDecodings('226')", numDecodings("226"))
	// fmt.Println("numDecodings('2611055971756562')", numDecodings("2611055971756562"))
	// fmt.Println("numDecodings('71756562')", numDecodings("71756562"))
}

func numDecodings(s string) int {
	allCombos := make([][]string, 0)
	current := make([]string, 0)
	findAll(&allCombos, current, 0, s)
	return len(validate(allCombos))
}

func findAll(all *[][]string, curr []string, index int, source string) {
	if index == len(source) {
			*all = append(*all, curr)
			return
	}
	
	curr1 := append(curr, string(source[index]))
	if index + 1 < len(source) {
			curr2 := append(curr, string(source[index:index+2]))
			findAll(all, curr2, index+2, source)
	}
	findAll(all, curr1, index+1, source)
	return 
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

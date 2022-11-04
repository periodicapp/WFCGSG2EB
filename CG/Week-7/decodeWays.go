package main

import(
	"fmt"
	"strconv"
)

// I changed this and it works better but still doesn't pass. I'll have to figure out if it's something in my validation or what.

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
	fmt.Println("ALL COMBOS:", allCombos)
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

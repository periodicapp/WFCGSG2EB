package main

import(
	"fmt"
	"math/bits"
)

// I didn't come up with this all on my own - had to learn about golang bits stuff a bit.
// It's a breeze when you have bits.OnesCount

func main() {
	fmt.Println("-- 1 LED ON --")
	fmt.Println(readBinaryWatch(1))
	fmt.Println()
	fmt.Println("-- 2 LED ON --")
	fmt.Println(readBinaryWatch(2))
	fmt.Println()
	fmt.Println("-- 3 LED ON --")
	fmt.Println(readBinaryWatch(3))
	fmt.Println()
	fmt.Println("-- 4 LED ON --")
	fmt.Println(readBinaryWatch(4))
	fmt.Println()
	fmt.Println("-- 5 LED ON --")
	fmt.Println(readBinaryWatch(5))
	fmt.Println()
	fmt.Println("-- 6 LED ON --")
	fmt.Println(readBinaryWatch(6))
	fmt.Println()
	fmt.Println("-- 7 LED ON --")
	fmt.Println(readBinaryWatch(7))
	fmt.Println()
}

func readBinaryWatch(turnedOn int) []string {
	allTimes := make([]string, 0)
	
	for i := 0; i < 12; i++ {
			numOnHours := bits.OnesCount(uint(i))
			for j := 0; j < 60; j++ {
					numOnMins := bits.OnesCount(uint(j))
					if (numOnHours + numOnMins) == turnedOn {
							allTimes = append(allTimes, getFormattedTime(i, j))
					}
			} 
	}
	return allTimes
}

func getFormattedTime(i, j int) string {
	var minutes string
	hours := fmt.Sprintf("%d", i)
	if j < 10 {
			minutes = fmt.Sprintf("%02d", j)
	} else {
			minutes = fmt.Sprintf("%01d", j)
	}
	return fmt.Sprintf("%s:%s", hours, minutes)
}
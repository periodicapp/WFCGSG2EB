package main

// Chris P.
import (
	"fmt"
)

// Problem: https://leetcode.com/problems/determine-if-two-events-have-conflict/description/

func main() {
	event1 := make([]string, 2)
	event2 := make([]string, 2)

	event1[0] = "01:15"
	event1[1] = "02:00"
	event2[0] = "02:00"
	event2[1] = "03:00"

	// event1[0] = "01:00"
	// event1[1] = "02:00"
	// event2[0] = "01:20"
	// event2[1] = "03:00"

	// event1[0] = "10:00"
	// event1[1] = "11:00"
	// event2[0] = "14:00"
	// event2[1] = "15:00"

	fmt.Println("Times: ", event1, event2)

	fmt.Println("Conflict:", haveConflict(event1, event2))

}

// Only part needed to run in LeetCode!
func haveConflict(event1 []string, event2 []string) bool {

	return event1[0] <= event2[1] && event2[0] <= event1[1]
}

// Explantation:

//  1:15 < 2:00 (true) && 2:00 <= 2:00 (true) = True

// 1:00 < 2:00 (true) && 1:20 < 3:00 (true) = True

// 10:00 < 14:00 (true) && 14:00 < 11:00 (false) = False

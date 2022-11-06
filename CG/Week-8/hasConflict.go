package main 

import(
	"strconv"
	"strings"
	"fmt"
)

// LeetCode Results:
// Runtime: 0 ms, faster than 100.00% of Go online submissions for Determine if Two Events Have Conflict.
// Memory Usage: 2.1 MB, less than 18.59% of Go online submissions for Determine if Two Events Have Conflict.

func main() {
	fmt.Println("(1:15-2:00), (2:00-3:00) has a conflict: ", haveConflict([]string{"01:15","02:00"},[]string{"02:00","03:00"}))
	fmt.Println("(8:00-12:00), (9:00-10:00) has a conflict: ", haveConflict([]string{"08:00","12:00"},[]string{"09:00","10:00"}))
	fmt.Println("(8:00-12:00), (9:00-13:00) has a conflict: ", haveConflict([]string{"08:00","12:00"},[]string{"09:00","13:00"}))
}

func haveConflict(event1, event2 []string) bool {
	e1Nums := convert(event1)
	e2Nums := convert(event2)
	
	// event1 encapsulates event2
	if isBefore(e1Nums[0], e2Nums[0]) && isAfter(e1Nums[1], e2Nums[1]) {
			return true
	// event2 encapsulates event1
	} else if isBefore(e2Nums[0], e1Nums[0]) && isAfter(e2Nums[1], e1Nums[1]) {
			return true
	// [08:00, 12:00], [09:00, 13:00]
	} else if isBefore(e1Nums[0], e2Nums[0]) && (isBefore(e1Nums[1], e2Nums[1]) && isAfter(e1Nums[1], e2Nums[0])) {
			return true
	// [09:00, 13:00], [08:00, 12:00]
	} else if isBefore(e2Nums[0], e1Nums[0]) && (isBefore(e2Nums[1], e1Nums[1]) && isAfter(e2Nums[1], e1Nums[0])) {
			return true
	}
	
	return false
}

/*
	Returns true if t1 is before t2
*/
func isBefore(t1, t2 [2]int) bool {
	if t1[0] == t2[0] {
			return t1[1] <= t2[1]
	} else if t1[0] < t2[0] {
			return true
	}
	
	return false
}

/*
	Returns true if t1 is after t2
*/
func isAfter(t1, t2 [2]int) bool {    
	if t1[0] == t2[0] {
			return t1[1] >= t2[1]
	} else if t1[0] > t2[0] {
			return true
	}
	
	return false
}

/*
	This takes ["01:23", "04:56"] and returns [[1, 23], [4, 56]]
*/
func convert(event []string) [2][2]int {
	eventStartHrs, _ := strconv.Atoi(strings.Split(event[0], ":")[0])
	eventStartMins, _ := strconv.Atoi(strings.Split(event[0], ":")[1])
	eventEndHrs, _ := strconv.Atoi(strings.Split(event[1], ":")[0])
	eventEndMins, _ := strconv.Atoi(strings.Split(event[1], ":")[1])
	return [2][2]int {
			[2]int {
					eventStartHrs,
					eventStartMins,
			},
			[2]int {
					eventEndHrs,
					eventEndMins,
			},
	}
}
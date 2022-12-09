package main

import (
	"fmt"
)

// LeetCode Results:
// Runtime: 105ms ms, faster than 82.35% of Go online submissions
// Memory Usage: 7.2 MB, less than 100% of Go online submissions

func main() {
	fmt.Println("")
}

// MyCalendar has an array of [2]int representing booked times
type MyCalendar struct {
	Times [][2]int
}

// In constructor, make an empty [][2]int to store booked times
func Constructor() MyCalendar {
	return MyCalendar{
		make([][2]int, 0),
	}
}

// If there are no currently booked times, return true and add the booked time
// Otherwise, check the given time against the list of booked times
// If one conflicts, return false, otherwise return true if none conflict
func (this *MyCalendar) Book(start int, end int) bool {
	// 0 booked times so far
	if len(this.Times) == 0 {
		newTime := [2]int{start, end}
		this.Times = append(this.Times, newTime)
		return true
	}

	// Check new time against existing times
	for i := 0; i < len(this.Times); i++ {
		if !timeIsAllowed(this.Times[i], start, end) {
			return false
		}
	}

	// No conflicts, add the time to list of booked and return true
	newTime := [2]int{start, end}
	this.Times = append(this.Times, newTime)
	return true
}

// Takes a time from the booked list ([2]int) and a new start/end to compare against it
func timeIsAllowed(bookedTime [2]int, start, end int) bool {
	if start >= bookedTime[0] && start < bookedTime[1] {
		// New start falls between booked time start/end
		return false
	} else if end > bookedTime[0] && end <= bookedTime[1] {
		// New end falls between booked time start/end
		return false
	} else if start < bookedTime[0] && end > bookedTime[1] || bookedTime[0] < start && bookedTime[1] > end {
		// New start/end encapsulate the booked time or vice-versa
		return false
	} else {
		// No conflicts
		return true
	}
}

package main

import (
	"fmt"
	"log"
)

type SlotPair struct {
	startTime int
	endTime   int
}

type MyCalendarThree struct {
	Slots []SlotPair
	Max   int
}

func Constructor() MyCalendarThree {
	return MyCalendarThree{}
}

func (this *MyCalendarThree) Book(startTime int, endTime int) int {

	if (startTime < 0 || startTime > 1000000000) || (endTime < 0 || endTime > 1000000000) {
		return 0
	}

	if (this.Slots == nil) || (len(this.Slots) == 0) {
		// Create slot and append if slots empty, return 1
		newSlot := SlotPair{
			startTime: startTime,
			endTime:   endTime,
		}

		this.Slots = append(this.Slots, newSlot)
		this.Max = 1
		return this.Max
	} else {
		log.Println("----- Slot to match: ", startTime, endTime)
		// add to slots
		counter := 0
		newSlot := SlotPair{
			startTime: startTime,
			endTime:   endTime,
		}

		this.Slots = append(this.Slots, newSlot)
		for _, slot := range this.Slots {
			counter = 0
			log.Println("Current slot: ", slot)
			// Check for slots overlap
			for _, secSlot := range this.Slots {
				if secSlot.startTime <= slot.endTime && secSlot.endTime >= slot.startTime && secSlot.endTime != slot.startTime {
					// if i == j {
					// 	continue
					// }
					counter++
					log.Print(secSlot, "-- counter: ", counter)
				}
			}

			if counter > this.Max {
				this.Max = counter
			}

		}

		return this.Max
	}
	// else {
	// 	// Insert slot first
	// 	newSlot := SlotPair{
	// 		startTime: startTime,
	// 		endTime:   endTime,
	// 	}

	// 	this.Slots = append(this.Slots, newSlot)

	// }

}

// func (this *MyCalendarThree) sort() {
// 	newSlots := []SlotPair{}
// 	currMaxDiffIndex := 0
// 	for _, currSlot := range this.Slots {

// 	}
// 	for i, slot := range this.Slots {
// 		if ((slot.endTime - slot.startTime) > (this.Slots[currMaxDiffIndex].endTime - this.Slots[currMaxDiffIndex].startTime)) {
// 			currMaxDiffIndex = i
// 		}
// 	}
// }

/**
 * Your MyCalendarThree object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.Book(startTime,endTime);
 */

func main() {
	obj := Constructor()
	p1 := obj.Book(10, 20)
	p2 := obj.Book(50, 60)
	p3 := obj.Book(10, 40)
	p4 := obj.Book(5, 15)
	p5 := obj.Book(5, 10)
	p6 := obj.Book(25, 55)

	fmt.Println(p1, p2, p3, p4, p5, p6)

}

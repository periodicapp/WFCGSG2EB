package main

import (
	"fmt"
	"log"
)

type SlotPair struct {
	startTime int
	endTime   int
}

type MyCalendar struct {
	Slots []SlotPair
	Max   int
}

func Constructor() MyCalendar {
	return MyCalendar{}
}

func (this *MyCalendar) Book(startTime int, endTime int) bool {

	if (startTime < 0 || startTime > 1000000000) || (endTime < 0 || endTime > 1000000000) {
		return false
	}

	if (this.Slots == nil) || (len(this.Slots) == 0) {
		// Create slot and append if slots empty, return 1
		newSlot := SlotPair{
			startTime: startTime,
			endTime:   endTime,
		}

		this.Slots = append(this.Slots, newSlot)
		this.Max = 1
		return true
	} else {
		orig := this.Slots
		log.Println("Slot to match: ", startTime, endTime)
		counter := 0
		newSlot := SlotPair{
			startTime: startTime,
			endTime:   endTime,
		}

		this.Slots = append(this.Slots, newSlot)
		for _, slot := range this.Slots {
			log.Println("Current slot: ", slot)
			// Check for slots overlap
			if startTime <= slot.endTime && endTime >= slot.startTime {
				if endTime != slot.startTime && startTime != slot.endTime {
					counter++
					log.Print(" counter: ", counter)
				}

			}
		}

		// if counter > this.Max {
		// 	this.Max = counter
		// }
		if counter > 1 {
			this.Slots = orig
			return false
		} else {
			return true
		}
		// return this.Max
	}

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
	p2 := obj.Book(15, 25)
	p3 := obj.Book(20, 30)

	fmt.Println(p1, p2, p3)

}

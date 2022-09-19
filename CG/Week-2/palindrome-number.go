package main

import(
	"fmt"
)

func main() {
	fmt.Println("isPalindrome(121)", isPalindrome(121))
	fmt.Println("isPalindrome(123)", isPalindrome(123))
	fmt.Println("isPalindrome(0)", isPalindrome(0))
	fmt.Println("isPalindrome(5)", isPalindrome(5))
	fmt.Println("isPalindrome(123450)", isPalindrome(123450))
	fmt.Println("isPalindrome(-20)", isPalindrome(-20))
	fmt.Println("isPalindrome(15799751)", isPalindrome(15799751))
}

func isPalindrome(x int) bool {
	if (x < 0) { // If negative, it's false
			return false
	} else if (x / 10 == 0) { // If single digit, it's true
			return true  
	} else {
			numPlaces := countPlaces(x)
			// we will use numPlaces - 1 so that the keys in the map represent
			// the proper power of 10
			numPlaces--
			// A map to track what digit is at which place (by power of 10).
			// It'll be reversed, so like on 121, you should get a map like {2:1, 1:2, 0:1}
			// At the end, go through the k, v of the map and add up all the v*(10^k)
			// to get the reversed number
			placeMap := make(map[int]int)
			// a copy of x that can be changed during the loop
			xCopy := x
			// Populate the map
			for i := numPlaces; i >= 0; i-- {
					if (i == 0) {
							placeMap[numPlaces-i] = xCopy
					} else {
							placeMap[numPlaces-i] = xCopy / pow(10, i)
							xCopy = xCopy % pow(10, i)
					}
			}
			// If the number in the "ones" place is 0, it won't be a palindrome
			if (placeMap[0] == 0) {
					return false
			} else {
					// Build a reversed number based on the map
					reversed := 0
					for k, v := range placeMap {
							reversed += v * pow(10, k)
					}
					return reversed == x   
			}
	}
}

/*
* Assumes a number has at least 1 digit. Use recursive strategy to get the number
* of digits in the given number.
*/
func countPlaces(x int) int {
	if (x / 10 == 0) {
			return 1;
	} else {
			return 1 + countPlaces(x / 10)
	}
}

// get base^exp
func pow(base, exp int) int {
	returnNum := 1
	expCopy := exp - 1
	for expCopy >= 0 {
			returnNum = returnNum * base
			expCopy--
	}
	return returnNum
}
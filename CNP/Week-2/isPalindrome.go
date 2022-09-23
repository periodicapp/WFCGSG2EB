package main //CNP

import (
	"fmt"
	"strconv"
)

func main() {
	fmt.Println("isPalindrome:", isPalindrome(272))
	fmt.Println("isPalindromeStr:", isPalindromeStr("redivider"))
}

func isPalindrome(x int) bool {
	// Converting to Runes
	runes := []rune(strconv.Itoa(x))
	// Reversing
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	// Converting back to int
	y, err := strconv.Atoi(string(runes))
	// Comparing
	if err == nil && x == y {
		return true
	}
	return false
}

// Palindrome String
// List of palindrome strings: redivider, deified, civic, radar, level, rotor, kayak, reviver, racecar, madam,refer
func isPalindromeStr(str string) bool {
	// Initializing empty byte array
	result := []byte{}
	// Iterating through array in reverse
	for i := len(str) - 1; i >= 0; i-- {
		result = append(result, str[i])
	}
	// Returning true if str is palindrome
	return str == string(result)
}

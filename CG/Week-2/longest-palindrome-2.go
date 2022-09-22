package main 

import(
	"fmt"
)

// This one is inspired by a solution someone had posted in the forums.  It is much much faster than the solution I had come up with.

func main() {
	fmt.Println("longestPalindrome('acbbca')", longestPalindrome("acbbca"))
	fmt.Println("longestPalindrome('abcde')", longestPalindrome("abcde"))
	fmt.Println("longestPalindrome('abcdefgfedcba')", longestPalindrome("abcdefgfedcba"))
}

func longestPalindrome(s string) string {
	if len(s) == 1 {
		return s
	} else {
		longest := ""
		for i := 0; i < len(s); i++ {
			odd := findPalindrome(s, i, i)
			even := findPalindrome(s, i, i+1)
			if (len(odd) > len(longest)) {
				longest = odd
			}
			if (len(even) > len(longest)) {
				longest = even
			}
		}
		return longest
	}
}

func findPalindrome(s string, l, r int) string {
	for (l > 0 && r < len(s) && (s[l-1:l] == s[r:r+1])) {
		l--
		r++
	}

	return s[l:r]
}
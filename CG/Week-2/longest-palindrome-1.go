package main

import(
	"fmt"
)

// Leetcode did not like this solution enough to pass.  It works but it is too slow on big strings
// for Leetcode to pass it.  

func main() {
	fmt.Println("longestPalindrome('babad')", longestPalindrome("babad"))
	fmt.Println("longestPalindrome('cbbd')", longestPalindrome("cbbd"))
	fmt.Println("longestPalindrome(big example from leetcode)", longestPalindrome("ibvjkmpyzsifuxcabqqpahjdeuzaybqsrsmbfplxycsafogotliyvhxjtkrbzqxlyfwujzhkdafhebvsdhkkdbhlhmaoxmbkqiwiusngkbdhlvxdyvnjrzvxmukvdfobzlmvnbnilnsyrgoygfdzjlymhprcpxsnxpcafctikxxybcusgjwmfklkffehbvlhvxfiddznwumxosomfbgxoruoqrhezgsgidgcfzbtdftjxeahriirqgxbhicoxavquhbkaomrroghdnfkknyigsluqebaqrtcwgmlnvmxoagisdmsokeznjsnwpxygjjptvyjjkbmkxvlivinmpnpxgmmorkasebngirckqcawgevljplkkgextudqaodwqmfljljhrujoerycoojwwgtklypicgkyaboqjfivbeqdlonxeidgxsyzugkntoevwfuxovazcyayvwbcqswzhytlmtmrtwpikgacnpkbwgfmpavzyjoxughwhvlsxsgttbcyrlkaarngeoaldsdtjncivhcfsaohmdhgbwkuemcembmlwbwquxfaiukoqvzmgoeppieztdacvwngbkcxknbytvztodbfnjhbtwpjlzuajnlzfmmujhcggpdcwdquutdiubgcvnxvgspmfumeqrofewynizvynavjzkbpkuxxvkjujectdyfwygnfsukvzflcuxxzvxzravzznpxttduajhbsyiywpqunnarabcroljwcbdydagachbobkcvudkoddldaucwruobfylfhyvjuynjrosxczgjwudpxaqwnboxgxybnngxxhibesiaxkicinikzzmonftqkcudlzfzutplbycejmkpxcygsafzkgudy"))
}

func longestPalindrome(s string) string {
	for i := len(s); i > 0; i-- {
			substrings := getPalindromeSubstringsOfLength(s, i)
			if (len(substrings) > 0) {
				return substrings[0]
			}
	}
	return ""
}

func getPalindromeSubstringsOfLength(str string, length int) []string {
	allSubs := make([]string, 0)
	if (len(str) == length) {
			if (str == reverseString(str)) {
				return append(allSubs, str)
			} else {
				return make([]string, 0)
			}
	} else {
			start := 0
			end := length
			for end <= len(str) {
					if (str[start:end] == reverseString(str[start:end])) {
						allSubs = append(allSubs, str[start:end])
					}
					start++
					end++
			}
			return allSubs
	}
}

func reverseString(s string) string {
	charArr := []rune(s)
	newCharArr := make([]rune, len(charArr))
	lastIndex := len(charArr) - 1
	for i := len(charArr)-1; i >= 0; i-- {
			newCharArr[lastIndex - i] = charArr[i]
	}
	return string(newCharArr)
}
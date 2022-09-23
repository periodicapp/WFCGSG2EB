package main

import "fmt"

func longestPalindromeSubstring(input string) string {
	if len(input) <= 1 {
		return input
	}
	start, maxLength := 0, 1
	for i := 0; i < (len(input) - maxLength/2); i++ {
		newStart, newMaxLength := expandSearch(input, i, i)
		if newMaxLength > maxLength {
			start = newStart
			maxLength = newMaxLength
		}
		newStart, newMaxLength = expandSearch(input, i, i+1)
		if newMaxLength > maxLength {
			start = newStart
			maxLength = newMaxLength
		}
	}
	return input[start : start+maxLength]
}

func expandSearch(inputString string, i, j int) (int, int) {
	for i >= 0 && j < len(inputString) && inputString[i] == inputString[j] {
		i--
		j++
	}
	return i + 1, j - i - 1
}

func main() {
	inputString := "fmitmmdqnpqqjjljpdplsemrvswqkaibctnvwcznilnfxaabwqdcuocuqespfmvkpalxfffozbjgfooeotuwxyutfetcixrqjswbfmadsrxpgpgwslspujoxaaoqfhdopgbtceaqysgwafsgrktsdimbbetnficmsvbmbcdisrajkzduyakjeehaeqsnjgzwfekezulzzluzekefwzgjnsqeaheejkayudzkjarsidcbmbvsmcifntebbmidstkrgsfawgsyqaectbgpodhfqoaaxojupslswgpgpxrsdamfbwsjqrxicteftuyxwutoeoofgjbzofffxlapkvmfpsequcoucdqwbaaxfnlinzcwvntcbiakqwsvrmeslpdpjljjqqpnqdmmtimffmitmmdqnpqqjjljpdplsemrvswqkaibctnvwcznilnfxaabwqdcuocuqespfmvkpalxfffozbjgfooeotuwxyutfetcixrqjswbfmadsrxpgpgwslspujoxaaoqfhdopgbtceaqysgwafsgrktsdimbbetnficmsvbmbcdisrajkzduyakjeehaeqsnjgzwfekezulzzluzekefwzgjnsqeaheejkayudzkjarsidcbmbvsmcifntebbmidstkrgsfawgsyqaectbgpodhfqoaaxojupslswgpgpxrsdamfbwsjqrxicteftuyxwutoeoofgjbzofffxlapkvmfpsequcoucdqwbaaxfnlinzcwvntcbiakqwsvrmeslpdpjljjqqpnqdmmtimfpadding"
	result := longestPalindromeSubstring(inputString)
	fmt.Println(result)
}

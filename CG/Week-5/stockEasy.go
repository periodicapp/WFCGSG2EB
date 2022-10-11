package main 

import(
	"fmt"
)

// https://leetcode.com/problems/best-time-to-buy-and-sell-stock/
// Runtime: 124 ms, faster than 92.26% of Go online submissions for Best Time to Buy and Sell Stock.
// Memory Usage: 8.1 MB, less than 90.36% of Go online submissions for Best Time to Buy and Sell Stock.

func main() {
	prices1 := []int{7,1,5,3,6,4}
	prices2 := []int{2,4,1}

	fmt.Println("Max Profit [7,1,5,3,6,4] (expecting 5): ", maxProfit(prices1))
	fmt.Println("Max Profit [2,4,1] (expecting 2): ", maxProfit(prices2))
}

func maxProfit(prices []int) int {
	currSale := 0 // init at 0 in case no sale can happen
	currHigh := prices[0] // init at first element
	currLow := prices[0] // init at first element
	for _, p := range prices { // loop through each price
		if p > currHigh { // increase currHigh if a higher price is seen
			currHigh = p
		}
		if p < currLow { // change currHigh AND currLow if a new low point is found
			currHigh = p
			currLow = p
		}
		if currHigh - currLow > currSale { // adjust the highest sale if necessary
			currSale = currHigh - currLow
		}
	}

	return currSale
}
package main 

import(
	"fmt"
)

// https://leetcode.com/problems/best-time-to-buy-and-sell-stock-ii/
// Runtime: 35 ms, faster than 5.59% of Go online submissions for Best Time to Buy and Sell Stock II.
// Memory Usage: 3.7 MB, less than 6.87% of Go online submissions for Best Time to Buy and Sell Stock II.

func main() {
	prices1 := []int{7,1,5,3,6,4}
	prices2 := []int{1,2,3,4,5}
	prices3 := []int{6,1,3,2,4,7}
	prices4 := []int{2,4,1}
	prices5 := []int{2,1,2,0,1}
	prices6 := []int{3,2,6,5,0,3}

	fmt.Println("Max Profit [7,1,5,3,6,4] (expecting 7): ", maxProfit(prices1))
	fmt.Println("Max Profit [1,2,3,4,5] (expecting 4): ", maxProfit(prices2))
	fmt.Println("Max Profit [6,1,3,2,4,7] (expecting 7): ", maxProfit(prices3))
	fmt.Println("Max Profit [2,4,1] (expecting 2): ", maxProfit(prices4))
	fmt.Println("Max Profit [2,1,2,0,1] (expecting 2): ", maxProfit(prices5))
	fmt.Println("Max Profit [3,2,6,5,0,3] (expecting 7): ", maxProfit(prices6))
}

func maxProfit(prices []int) int {
	sales := make([]int, 0)
	currSale := 0
	currHigh := prices[0]
	currLow := prices[0]
	for i, p := range prices {
		if p > currHigh {
			currHigh = p
		}
		if p < currHigh {
			sales = append(sales, currSale)
			currSale = 0
			currLow = p
			currHigh = p
		}
		if currHigh > currLow {
			currSale = currHigh - currLow
		}
		if i == len(prices) - 1 {
			if currHigh > currLow {
				sales = append(sales, currHigh - currLow)
			}
		}
	}

	return sum(sales)
}

func sum(nums []int) int {
	sum := 0
	for _, n := range nums {
		sum += n
	}
	return sum
}
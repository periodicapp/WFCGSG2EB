package main

import "fmt"

func maxProfit(prices []int) int {
	maxProfit := 0
	minPrice := prices[0]
	for i := 1; i < len(prices); i++ {
		if prices[i] < minPrice {
			minPrice = prices[i]
		} else {
			tmpProfit := prices[i] - minPrice
			if tmpProfit > maxProfit {
				maxProfit = tmpProfit
			}
		}

	}
	return maxProfit

}

func main() {
	prices := []int{7, 6, 4, 3, 1}
	result := maxProfit(prices)
	fmt.Println(result)

}


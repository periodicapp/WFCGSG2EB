from typing import List

class Solution:
    # Easy Solution
    def maxProfitI(self, prices: List[int]) -> int:
        # Current Buy index
        buy = 0
        # Current Sell index
        sell = 1
        highestProfit = 0
        while sell < len(prices):
            currentProfit = prices[sell] - prices[buy] 
            if prices[buy] < prices[sell]:
                highestProfit = max(currentProfit, highestProfit)
            else:
                buy = sell
            sell += 1
        return highestProfit
    
    def maxProfitII(self, prices: List[int]) -> int:
        # Current Sell index
        sell = 1
        highestProfit = 0
        while sell < len(prices):
            # "You can only hold at most one share of the stock at any time"
            # "However, you can buy it then immediately sell it on the same day" so we can also sell, then buy (sell-1)
            if prices[sell-1] < prices[sell]:
                highestProfit += prices[sell] - prices[sell-1] 
            sell += 1
        return highestProfit
    
    def maxProfitIII(self, prices: List[int]) -> int:
        # This method finds every combination of sells and buys that can be done
        # The helper is essentially the maxProfitI problem, but only looks within the given range (start to end inclusive)
        def helper(start, end):
            highestProfit = 0
            buy = start 
            for sell in range(start+1, end+1):
                highestProfit = max(highestProfit, prices[sell] - prices[buy])
                if prices[sell] < prices[buy]:
                    buy = sell
            return highestProfit
        days = len(prices)
        highestProfit = 0
        # This solution is too slow for leet code
        for i in range(days):
            currMax = helper(0, i) + helper(i+1, days-1)
            highestProfit = max(currMax, highestProfit)
        return highestProfit 
    
    # Cool leetcode solution
    def leetCodeON(self, prices):
        low, profit= prices[0], 0
        n = len(prices)
        # Creation of zero-filled n-length array
        maxBefore = [0]*n
        # Starting from the first day, find the max profit for every day using the lowest price up to the current date
        for i in range(1, n):
            # Populate the list with the largest profit for the given date range: 0 - i
            maxBefore[i] = max(prices[i]-low, maxBefore[i-1])
            print("low", low, "| prices[i]", prices[i], "| maxBefore[i-1]", maxBefore[i-1])
            print(maxBefore)
            if prices[i] < low:
                low = prices[i]
            print()
        print('------------------------------------------')
        # By the end of this, we will now have the largest profit to date in the array, meaning the largest profit will be the last element in the list
        # Now we do a similar process but using the highest price in the list of prices
        high = prices[n-1]
        gain = 0
        # Now we need to figure out the most profit possible for 2 transactions
        # Loop through the list from the 2nd last day till the first day
        for i in range(n-2, -1, -1):
            print("high", high, "| prices[i]", prices[i], "| maxBefore[i]", maxBefore[i], ":", high - prices[i] + maxBefore[i])
            # Our current highest price - the price of the day at i + our highest profit at i
            gain = max(gain, (high - prices[i]) + maxBefore[i])
            if high<prices[i]:
                high = prices[i]
        return gain 
    

prices = [6,1,3,2,4,7]        

# prices = [7,1,5,3,6,4]
# prices = [1,2,3,4,5,6,7,8,9,10]
# # prices = [7,6,4,3,1]
# # prices = [1,2,3,4,5]
# # prices = [7,6,5,4,3,2,1]
# # prices = [2,4,1]
# # prices = [1,2,3,4,5]
# # prices = [5,3,4,2,3,10]
# prices = [1, 2, 3, 4, 5, 9, 10]
# prices = [3,3,5,0,0,3,1,4]
# # prices = [1,2,3,4,5]
# # prices = [2,1,2,0,1]
# # prices = [2,4,1]
# prices = [3,2,6,5,0,3]
a = Solution()
# print(a.maxProfitIII(prices)) 
print(a.leetCodeON(prices)) 
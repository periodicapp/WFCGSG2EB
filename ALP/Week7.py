from typing import List

class Solution:
    # ------------------------------------------------------- EASY
    
    # 0: 0000 - 0 Lights
    # 1: 0001 - 1 Lights
    # 2: 0010 - 1 Lights
    # 3: 0011 - 2 Lights
    # 4: 0100 - 1 Lights
    # 5: 0101 - 2 Lights
    # 6: 0110 - 2 Lights
    # 7: 0111 - 3 Lights
    # 8: 1000 - 1 Lights
    # 9: 1001 - 2 Lights
    #10: 1010 - 2 Lights
    #11: 1011 - 3 Lights
    #12: 1100 - 2 Lights
    # 10:12 = 1010:1100 
    # bin(10) + bin(12) = 0b10100b1100 - 4 Lights (Python only concats the binary representations, because bin() returns a string representation)
    def readBinaryWatch(self, turnedOn: int) -> List[str]:
        return [f'{h:d}:{m:02d}' for h in range(12) for m in range(60) if (bin(h) + bin(m)).count('1') == turnedOn]
        # list = []  
        # for h in range(12): 
        #     for m in range(60):
        #         if (bin(h) + bin(m)).count('1') == turnedOn:
        #               list.append(f'{h:d}:{m:02d}')

    # ------------------------------------------------------- MEDIUM
    # Too Slow
    def numDecodings(self, s: str) -> int:
        def helper(s: str) -> List[List[str]]:
            if len(s) > 1:
                res = helper(s[1:])
                l = []
                for x in res:
                    a = [s[0], *x]
                    l.append(a)
                res = helper(s[2:])
                for x in res:
                    a = [s[0]+s[1], *x]
                    l.append(a)
                return l
            else:
                return [s]
        count = 0
        x = 0
        sol = helper(s)
        x = 0
        while x < len(sol):
            for y in sol[x]:
                if y[0] == '0':
                    sol.pop(x)
                    x-=1
                    break
                if int(y) >= 27:
                    sol.pop(x)
                    x-=1
                    break
            x += 1
        return len(sol)
    # Bottom Up Dynamic Programming solution 
    def numDecodingsRedux(self, s: str) -> int:
        # Array of len(s)+1
        dp = [0] * (len(s)+1)
        # Every string has at least 1 combo (unless they start at 0, but this will be resolved at the end, when the final number is populated as 0)
        dp[len(s)] = 1
        # Start after last index
        i = len(s)-1
        while i >= 0:
            # For every number except 0, we can continue our combination count
            if s[i] != '0':
                # Continue from our combination count
                dp[i] = dp[i+1]
            # Check the next value to see if we can have a 2 or 1 digit number (which would create another combination possibility)
            if i+1 < len(s):
                # If the number is 1, then any other number can work to make it two digits
                if s[i] == '1':
                    # Grow the combo count 
                    dp[i] += dp[i+2]
                # If the number is 2, we only want 20-26
                elif s[i] == '2' and s[i+1] <= '6':
                    # Grow the combo count 
                    dp[i] += dp[i+2]
            # print(dp)
            i -= 1
        return dp[0]
                     
    # ------------------------------------------------------- HARD
    # [0, 0, 0, 0, 0, 1]
    # '*' = 9 * dp[i+1] = 9 = [0, 0, 0, 0, 9, 1]
    # '**', we can have 81 combinations of numbers solo like - (3, 2), (4, 3), (5, 4)
    # But we can also have 9 Combinations with the second * as 1 and another number like - 12, 14, 15, 16
    # Then we can have 6 combinations of 2 and another number - 21, 22, 23, 24, 25, 26
    # '**' = 9 * dp[i+1] = 9*9 = 81 + 15 = 96 =   [0, 0, 0, 96, 9, 1]
    # '1**', we can have all the number of combinations as before just with a 1 in front like (1, 3, 2), (1, 4, 3), (1, 5, 4), but we can also
    # have 1(1-9), * like (11, 1), (12, 1), (13, 1), (14, 1) .... (19, 9)
    # '1**' = 96 + 9(dp[i+2]) * 9 = 177 = [0, 0, 177, 96, 9, 1]
    def numDecodingsH(self, s: str) -> int:
        dp = [0] * (len(s)+1)
        dp[len(s)] = 1
        i = len(s)-1
        while i >= 0:
            if s[i] == '*':
                dp[i] = dp[i+1] * 9
            elif s[i] != '0':
                dp[i] = dp[i+1]
            if i+1 < len(s):
                if s[i] == '1'and s[i+1] == '*':
                    dp[i] += dp[i+2] * 9
                elif s[i] == '2' and s[i+1] == '*':
                    dp[i] += dp[i+2] * 6
                elif s[i] == '*' and s[i+1] == '*':
                    dp[i] += dp[i+2] * 15
                elif s[i] == '*' and s[i+1] != '*' and s[i+1] <= '6':
                    dp[i] += dp[i+2] * 2
                elif s[i] == '*' and s[i+1] != '*' and s[i+1] > '6':
                    dp[i] += dp[i+2]
                elif s[i] == '2' and s[i+1] <= '6':
                    dp[i] += dp[i+2]
                elif s[i] == '1':
                    dp[i] += dp[i+2]
                if len(dp) > 20:
                    dp = dp[0:i+2]
                # print(dp)
            i -= 1
        return dp[0] % (10**9 + 7)
    
    # Queue Methodology
    def numDecodingsQueue(self, s: str) -> int:
        queue = [0, 1, 1]
        i = len(s)-1
        while i >= 0:
            x1 = queue.pop() #dp[i+2]
            x2 = queue.pop() #dp[i+1]
            x3 = queue.pop() #dp[i]
            if s[i] == '*':
                x3 = x2 * 9
            elif s[i] != '0':
                x3 = x2
            if i+1 < len(s):
                if s[i] == '1'and s[i+1] == '*':
                    x3 += x1 * 9
                elif s[i] == '2' and s[i+1] == '*':
                    x3 += x1 * 6
                elif s[i] == '*' and s[i+1] == '*':
                    x3 += x1 * 15
                elif s[i] == '*' and s[i+1] != '*' and s[i+1] <= '6':
                    x3 += x1 * 2
                elif s[i] == '*' and s[i+1] != '*' and s[i+1] > '6':
                    x3 += x1
                elif s[i] == '2' and s[i+1] <= '6':
                    x3 += x1
                elif s[i] == '1':
                    x3 += x1
            queue.append(0)
            queue.append(x3)
            queue.append(x2)
            i -= 1
        return queue[1] % (10**9 + 7)

# 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 1*
a = Solution()
print(a.readBinaryWatch(1))
print(a.numDecodingsRedux("111140"))
print(a.numDecodingsRedux('456786'))
print(a.numDecodingsH("*2*1*1*1*"))
print(a.numDecodingsQueue("**1*2**"))
    
    

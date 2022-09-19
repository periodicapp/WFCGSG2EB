from typing import List, Tuple


class Solution:
    def fourSum(self, nums: List[int], target: int) -> List[List[int]]:
        def anySum(length: int, nums: List[int], target: int) -> List[List[int]]:
            ans = []
            # No numbers left to iterate through
            if not nums:
                return ans 
            # Smallest number is too large, cannot add 4 numbers together to get target
            if nums[0] > (target / length):
                return ans 
            # Largest number is too small, cannot add 4 numbers together to get target
            if nums[len(nums)-1] < (target / length):
                return ans
            # Pass to two sum
            if length == 2:
                return twoSum(nums, target)

            for x in range(len(nums)):
                # Skipping duplicate numbers
                if x == 0 or nums[x - 1] != nums[x]:
                    # Recurse through the list  checking every possibility with a new target
                    posAns = anySum(length-1, nums[x+1:], target - nums[x])
                    # appending the current number to get a set of the current set length (triplet, quadruplet, ect...)
                    for z in posAns:
                        z.append(nums[x])
                        if not z in ans:
                            ans.append(z)
            return ans
            
        def twoSum(nums: List[int], target: int) -> List[List[int]]:
            ans = []
            start = 0
            end = len(nums)-1
            
            while start < end:
                if nums[start] + nums[end] == target:
                    ans.append([nums[start], nums[end]])
                    start += 1
                    end -= 1
                if nums[start] + nums[end] > target:
                    end -= 1
                if nums[start] + nums[end] < target:
                    start += 1
            return ans
        
        nums.sort()
        return anySum(4, nums, target)
        
    
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        ans = []
        nums.sort()
        for x in range(len(nums)-1):
            y = x + 1
            z = len(nums) - 1
            while y < z:
                if nums[y] + nums[z] + nums[x] == 0:
                    posAns = [nums[x], nums[y], nums[z]]
                    if not posAns in ans:
                        ans.append(posAns)
                    y += 1
                    z -= 1
                elif  nums[y] + nums[z] + nums[x] > 0:
                    z -= 1
                else:
                    y += 1
            
        return ans
    
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        ansDict = {}
        for x in range(0, len(nums)):
            curr = nums[x]
            remain = target - curr
            if remain in ansDict:
                return [ansDict[remain], x]
            ansDict[curr] = x

a = Solution()
print(a.twoSum([3, 2, 4], 6))
print(a.threeSum([0,1,1]))
print(a.threeSum([0,0,0]))
print(a.threeSum([-1,0,1,2,-1,-4,-2,-3,3,0,4]))
print([1,0,-1,0,-2,2])
print(a.fourSum([1,0,-1,0,-2,2], 0))
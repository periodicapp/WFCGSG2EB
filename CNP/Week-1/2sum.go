package main
// Brute - Complexity == o(n^2) - two loops
func twoSum_brute(nums []int, target int) []int {
	for i, firstNum := range nums {
		for j, secondNum := range nums {
			if firstNum+secondNum == target && i != j {
				return []int{i, j}
			}
		}
	}
	return nil
}


// Complexity == O(n) - due to single loop
func twoSum_hashmap(nums []int, target int) []int {
    // Create Hashmap
    numMap := make(map[int]int)
    
    // Iterate over hashmap
    for i, num := range(nums) {
        _, ok := numMap[num]
        if ok == true {
            return []int{i, numMap[num]}
        }
        // Getting Compliment        
        numMap[target - num] = i
    }
    //Return Nothing
    return nil
}

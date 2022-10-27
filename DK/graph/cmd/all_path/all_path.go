package main

import "fmt"

func main() {
	tcArr := []struct {
		Given [][]int
		Want  [][]int
	}{
		{
			Given: [][]int{
				{1, 2},
				{3},
				{3},
				{},
			},
			Want: [][]int{
				{0, 1, 3},
				{0, 2, 3},
			},
		},
		{
			Given: [][]int{
				{4, 3, 1},
				{3, 2, 4},
				{3},
				{4},
				{},
			},
			Want: [][]int{
				{0, 4},
				{0, 3, 4},
				{0, 1, 3, 4},
				{0, 1, 2, 3, 4},
				{0, 1, 4},
			},
		},
	}

	for i, tc := range tcArr {
		if i == 1 {
			ret := allPathsSourceTarget(tc.Given)
			fmt.Printf("TC: %+v\n", tc)
			fmt.Printf("Expected: %+v; Got: %+v\n", tc.Want, ret)
		}
	}
}

func allPathsSourceTarget(graph [][]int) [][]int {
	var stack = make([]int, 0)
	var visited = make([]int, 0)
	stack = append(stack, 0)
	var finalArr = make([][]int, 0)
	visitTopNode(stack, visited, graph, finalArr)
	return nil

}

func visitTopNode(stack []int, visited []int, graph [][]int, finalArr [][]int) {
	currStackLen := len(stack)
	if currStackLen == 0 {
		return
	}
	top := stack[currStackLen-1]
	fmt.Printf("Current stack top: %d\n", top)
	if top == len(graph)-1 {
		fmt.Printf("Found path!\n")
		temp := append(visited, top)
		finalArr = append(finalArr, temp)
		fmt.Printf("Final arr: %+v\n", finalArr)
	} else {
		visited = append(visited, top)
	}

	fmt.Printf("Visited: %+v\n", visited)
	fmt.Printf("Stack: %+v\n", stack)
	stack = stack[:len(stack)-1]

	stack = append(stack, graph[top]...)
	visitTopNode(stack, visited, graph, finalArr)
}

func contains(arr []int, elem int) bool {
	for _, val := range arr {
		if elem == val {
			return true
		}
	}
	return false
}

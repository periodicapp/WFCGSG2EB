package main

import "fmt"

type TestCase struct {
	Vertices    int
	Edges       [][]int
	Source      int
	Destination int
}

func main() {
	//Test Case 1
	var test1 TestCase
	test1.Vertices = 3
	test1.Edges = [][]int{
		{0, 1}, {1, 2}, {2, 0},
	}
	test1.Source = 0
	test1.Destination = 2
	//Test Case 2
	var test2 TestCase
	test2.Vertices = 6
	test2.Edges = [][]int{
		{0, 1}, {0, 2}, {3, 5}, {5, 4}, {4, 3},
	}
	test2.Source = 0
	test2.Destination = 5

	fmt.Println("Test Case 1:", test1)
	fmt.Printf("Has valid path: %t\n\n", validPath(test1.Vertices, test1.Edges, test1.Source, test1.Destination))
	fmt.Println("Test Case 2:", test2)
	fmt.Printf("Has valid path: %t\n\n", validPath(test2.Vertices, test2.Edges, test2.Source, test2.Destination))
}

func validPath(n int, edges [][]int, source int, destination int) bool {
	queue := make([]int, 0)
	seen := make([]bool, n)
	// init graph
	graph := make(map[int][]int)
	for _, e := range edges {
		graph[e[0]] = append(graph[e[0]], e[1])
		graph[e[1]] = append(graph[e[1]], e[0])
	}

	// init seen and visit source
	for i := 0; i < n; i++ {
		seen[i] = false
	}
	seen[source] = true

	// add source to queue
	queue = append(queue, source)

	// while there's something in the queue, check neighbors. If they haven't been visited add them to the queue and mark them as visited
	for len(queue) > 0 {
		curr_node := queue[0]
		queue = queue[1:len(queue)]
		if curr_node == destination {
			return true
		}
		for _, neighbor := range graph[curr_node] {
			if !seen[neighbor] {
				seen[neighbor] = true
				queue = append(queue, neighbor)
			}
		}
	}

	return false
}

func contains(arr []int, n int) bool {
	for _, el := range arr {
		if el == n {
			return true
		}
	}
	return false
}

package main

import (
	"fmt"
)

func main() {
	tcArr := []struct {
		N           int
		Edges       [][]int
		Source      int
		Destination int
		Want        bool
	}{
		{
			N: 3,
			Edges: [][]int{
				{0, 1},
				{1, 2},
				{2, 0},
			},
			Source:      0,
			Destination: 2,
			Want:        true,
		},
		{
			N: 6,
			Edges: [][]int{
				{0, 1},
				{0, 2},
				{3, 5},
				{5, 4},
				{4, 3},
			},
			Source:      0,
			Destination: 5,
			Want:        false,
		},
		{
			N: 10,
			Edges: [][]int{
				{4, 3},
				{1, 4},
				{4, 8},
				{1, 7},
				{6, 4},
				{4, 2},
				{7, 4},
				{4, 0},
				{0, 9},
				{5, 4},
			},
			Source:      5,
			Destination: 9,
			Want:        true,
		},
		{
			N: 10,
			Edges: [][]int{
				{0, 7},
				{0, 8},
				{6, 1},
				{2, 0},
				{0, 4},
				{5, 8},
				{4, 7},
				{1, 3},
				{3, 5},
				{6, 5},
			},
			Source:      7,
			Destination: 5,
			Want:        true,
		},
	}

	for i, tc := range tcArr {
		if i != 33 {
			ret := validPath(tc.N, tc.Edges, tc.Source, tc.Destination)
			fmt.Printf("TC: %+v\n", tc)
			fmt.Printf("Expected: %t; Got: %t\n", tc.Want, ret)
		}

	}
}

var visited map[int]bool

func validPath(n int, edges [][]int, source int, destination int) bool {
	if n == 1 || len(edges) == 0 || (source == destination) {
		return true
	}
	newMap := buildMap(edges)
	visited = make(map[int]bool)
	fmt.Printf("Map: %+v\n", newMap)
	foundNode := traverseGraph(source, source, destination, newMap)
	return foundNode
}

func traverseGraph(parent int, current int, destination int, newMap map[int][]int) bool {
	reachables, _ := newMap[current]
	var foundNode bool
	for _, reachable := range reachables {
		if reachable == parent {
			continue
		} else if visited[reachable] == true {
			continue
		} else if reachable == destination {
			return true
		} else {
			visited[reachable] = true
			foundNode = traverseGraph(current, reachable, destination, newMap)
			if foundNode {
				return true
			}
		}

	}
	return foundNode
}

func buildMap(edges [][]int) map[int][]int {
	var newMap = make(map[int][]int, 0)
	for _, pair := range edges {
		newMap[pair[0]] = append(newMap[pair[0]], pair[1])
		newMap[pair[1]] = append(newMap[pair[1]], pair[0])
	}
	return newMap
}

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

	for _, tc := range tcArr {
		if true {
			ret := allPathsSourceTarget(tc.Given)
			fmt.Printf("TC: %+v\n", tc)
			fmt.Printf("Expected: %+v; Got: %+v\n", tc.Want, ret)
		}
	}
}

func allPathsSourceTarget(graph [][]int) [][]int {

	return nil

}

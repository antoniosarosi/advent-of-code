package solutions

import "github.com/antoniosarosi/advent-of-code/solutions/go/pkg/year2022"

type Solution = func(string) (int, int)

func GetSolution(key string) Solution {
	solutions := map[string]Solution{
		"2022/01": year2022.Day1,
		"2022/02": year2022.Day2,
	}

	return solutions[key]
}

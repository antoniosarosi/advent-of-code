package main

import "aoc/year2022"

type Solution = func(string) (int, int)

func GetSolution(key string) Solution {
	solutions := map[string]Solution{
		"2022/01": year2022.Day1,
	}

	return solutions[key]
}

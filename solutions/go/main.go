package main

import (
	"fmt"
	"os"
	"strconv"
)

func fail(format string, args ...any) {
	fmt.Fprintf(os.Stderr, format, args...)
	os.Exit(1)
}

func main() {
	if len(os.Args) < 3 || len(os.Args) > 4 {
		fail("Usage: %s YEAR DAY [path/to/alternate/input.txt]", os.Args[0])
	}

	year, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fail("Cannot parse year: '%s'", os.Args[1])
	}

	day, err := strconv.Atoi(os.Args[2])
	if err != nil {
		fail("Cannot parse day: '%s'", os.Args[2])
	}

	inputFile := fmt.Sprintf("./inputs/%d/day%02d.txt", year, day)
	if len(os.Args) == 4 {
		inputFile = os.Args[3]
	}

	solution := GetSolution(fmt.Sprintf("%d/%02d", year, day))
	if solution == nil {
		fail("Solution for year %d day %d is no implemented or registered", year, day)
	}

	input, err := os.ReadFile(inputFile)
	if err != nil {
		fail("Could not read input file: %s", err)
	}

	part1, part2 := solution(string(input))

	fmt.Printf("%d\n%d", part1, part2)
}

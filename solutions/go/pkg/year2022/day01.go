package year2022

import (
	"slices"
	"strconv"
	"strings"
)

func parseTotalCalories(input string) []int {
	elves := strings.Split(strings.TrimSpace(input), "\n\n")
	var totalCalories []int

	for _, elf := range elves {
		calories := 0
		for _, cal := range strings.Split(elf, "\n") {
			cal, err := strconv.Atoi(cal)
			if err != nil {
				panic(err)
			}
			calories += cal
		}
		totalCalories = append(totalCalories, calories)
	}

	return totalCalories
}

func day1Part1(calories []int) int {
	return slices.Max(calories)
}

func day1Part2(calories []int) int {
	topThree := []int{0, 0, 0}
	for _, cal := range calories {
		for i := 0; i < len(topThree); i++ {
			if cal > topThree[i] {
				for j := 2; j > 0; j-- {
					topThree[j] = topThree[j-1]
				}
				topThree[i] = cal
				break
			}
		}
	}

	return topThree[0] + topThree[1] + topThree[2]
}

func Day1(input string) (string, string) {
	calories := parseTotalCalories(input)

	return strconv.Itoa(day1Part1(calories)), strconv.Itoa(day1Part2(calories))
}

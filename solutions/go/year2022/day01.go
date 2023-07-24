package year2022

import (
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

func part1(calories []int) int {
	max := 0
	for _, cal := range calories {
		if cal > max {
			max = cal
		}
	}

	return max
}

func part2(calories []int) int {
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

func Day1(input string) (int, int) {
	calories := parseTotalCalories(input)

	return part1(calories), part2(calories)
}

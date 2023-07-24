package year2022

import (
	"fmt"
	"strings"
)

const (
	Loss int = 0
	Draw int = 3
	Win  int = 6
)

const (
	Rock     int = 1
	Paper    int = 2
	Scissors int = 3
)

type Round struct {
	Player  int
	Oponent int
}

func parseOponentShape(encoded string) int {
	switch encoded {
	case "A":
		return Rock
	case "B":
		return Paper
	case "C":
		return Scissors
	default:
		panic(fmt.Errorf("Unexpected oponent shape: %s", encoded))
	}
}

func parsePlayerShape(encoded string) int {
	switch encoded {
	case "X":
		return Rock
	case "Y":
		return Paper
	case "Z":
		return Scissors
	default:
		panic(fmt.Errorf("Unexpected player shape: %s", encoded))
	}
}

func parsePlayerResult(encoded string) int {
	switch encoded {
	case "X":
		return Loss
	case "Y":
		return Draw
	case "Z":
		return Win
	default:
		panic(fmt.Errorf("Unexpected player result: %s", encoded))
	}
}

func calculateRoundResult(player, oponent int) int {
	if (player == Rock && oponent == Scissors) ||
		(player == Paper && oponent == Rock) ||
		(player == Scissors && oponent == Paper) {
		return Win
	}

	if (player == Scissors && oponent == Rock) ||
		(player == Paper && oponent == Scissors) ||
		(player == Rock && oponent == Paper) {
		return Loss
	}

	return Draw
}

func getNecessaryShapeForResult(result, oponent int) int {
	if (result == Loss && oponent == Paper) ||
		(result == Draw && oponent == Rock) ||
		(result == Win && oponent == Scissors) {
		return Rock
	}

	if (result == Loss && oponent == Scissors) ||
		(result == Draw && oponent == Paper) ||
		(result == Win && oponent == Rock) {
		return Paper
	}

	return Scissors
}

func parseGame(input string, parsePlayer func(string) int) []Round {
	var game []Round

	for _, line := range strings.Split(strings.TrimSpace(input), "\n") {
		split := strings.Split(line, " ")
		oponent := parseOponentShape(split[0])
		player := parsePlayer(strings.TrimSpace(split[1]))
		game = append(game, Round{player, oponent})
	}

	return game
}

func playGame(game []Round, calculatePoints func(int, int) int) int {
	totalPoints := 0

	for _, round := range game {
		totalPoints += calculatePoints(round.Player, round.Oponent)
	}

	return totalPoints
}

func day2Part1(game []Round) int {
	return playGame(game, func(player, oponent int) int {
		return player + calculateRoundResult(player, oponent)
	})
}

func day2Part2(game []Round) int {
	return playGame(game, func(player, oponent int) int {
		return player + getNecessaryShapeForResult(player, oponent)
	})
}

func Day2(input string) (int, int) {
	part1 := parseGame(input, parsePlayerShape)
	part2 := parseGame(input, parsePlayerResult)

	return day2Part1(part1), day2Part2(part2)
}

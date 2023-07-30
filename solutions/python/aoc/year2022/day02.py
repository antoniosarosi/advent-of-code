from enum import Enum
from typing import TypeVar, overload


class Shape(Enum):
    ROCK = 1
    PAPER = 2
    SCISSORS = 3


class RoundResult(Enum):
    LOSS = 0
    DRAW = 3
    WIN = 6


class OponentShape(Enum):
    ROCK = "A"
    PAPER = "B"
    SCISSORS = "C"


# Part 1: X, Y and Z are the hand shapes that we should play each round.
class PlayerShape(Enum):
    ROCK = "X"
    PAPER = "Y"
    SCISSORS = "Z"

    @property
    def points(self) -> int:
        return Shape[self.name].value

    def result_against(self, oponent: OponentShape) -> RoundResult:
        match (self, oponent):
            case (
                (self.ROCK, oponent.SCISSORS)
                | (self.PAPER, oponent.ROCK)
                | (self.SCISSORS, oponent.PAPER)
            ):
                return RoundResult.WIN

            case (
                (self.SCISSORS, oponent.ROCK)
                | (self.PAPER, oponent.SCISSORS)
                | (self.ROCK, oponent.PAPER)
            ):
                return RoundResult.LOSS

            case _:
                return RoundResult.DRAW

    def round_points(self, oponent: OponentShape) -> int:
        return self.points + self.result_against(oponent).value


# Part 2: X, Y and Z are the results that we should enforce each round.
class PlayerResult(Enum):
    LOSS = "X"
    DRAW = "Y"
    WIN = "Z"

    @property
    def points(self) -> int:
        return RoundResult[self.name].value

    def necessary_shape_against(self, oponent: OponentShape) -> Shape:
        match (self, oponent):
            case (
                (self.LOSS, oponent.PAPER)
                | (self.DRAW, oponent.ROCK)
                | (self.WIN, oponent.SCISSORS)
            ):
                return Shape.ROCK

            case (
                (self.LOSS, oponent.SCISSORS)
                | (self.DRAW, oponent.PAPER)
                | (self.WIN, oponent.ROCK)
            ):
                return Shape.PAPER

            case _:
                return Shape.SCISSORS

    def round_points(self, oponent: OponentShape) -> int:
        return self.points + self.necessary_shape_against(oponent).value


P = TypeVar("P", PlayerShape, PlayerResult)
Game = list[tuple[OponentShape, P]]


@overload
def parse_game(input: str, parser: type[PlayerShape]) -> Game[PlayerShape]:
    ...


@overload
def parse_game(input: str, parser: type[PlayerResult]) -> Game[PlayerResult]:
    ...


def parse_game(
    input: str, parser: type[PlayerShape] | type[PlayerResult]
) -> Game[PlayerResult] | Game[PlayerShape]:
    game = []
    for round in input.strip().split("\n"):
        oponent, player = round.split(" ")
        game.append((OponentShape(oponent), parser(player)))

    return game


def play_game(game: Game[PlayerResult] | Game[PlayerShape]) -> int:
    return sum(player.round_points(oponent) for oponent, player in game)


def solution(input: str) -> tuple[int, int]:
    part1 = parse_game(input, PlayerShape)
    part2 = parse_game(input, PlayerResult)

    return play_game(part1), play_game(part2)

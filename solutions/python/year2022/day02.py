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

    def result_against(self, oponent_shape: OponentShape) -> RoundResult:
        match (self, oponent_shape):
            case (
                (self.ROCK, OponentShape.SCISSORS)
                | (self.PAPER, OponentShape.ROCK)
                | (self.SCISSORS, OponentShape.PAPER)
            ):
                return RoundResult.WIN

            case (
                (self.SCISSORS, OponentShape.ROCK)
                | (self.PAPER, OponentShape.SCISSORS)
                | (self.ROCK, OponentShape.PAPER)
            ):
                return RoundResult.LOSS

            case _:
                return RoundResult.DRAW


# Part 2: X, Y and Z are the results that we should enforce each round.
class PlayerResult(Enum):
    LOSS = "X"
    DRAW = "Y"
    WIN = "Z"

    @property
    def points(self) -> int:
        return RoundResult[self.name].value

    def necessary_shape_against(self, oponent_shape: OponentShape) -> Shape:
        match (self, oponent_shape):
            case (
                (self.LOSS, oponent_shape.PAPER)
                | (self.DRAW, oponent_shape.ROCK)
                | (self.WIN, oponent_shape.SCISSORS)
            ):
                return Shape.ROCK

            case (
                (self.LOSS, oponent_shape.SCISSORS)
                | (self.DRAW, oponent_shape.PAPER)
                | (self.WIN, oponent_shape.ROCK)
            ):
                return Shape.PAPER

            case _:
                return Shape.SCISSORS


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


def part1(game: Game[PlayerShape]) -> int:
    score = 0
    for oponent, player in game:
        score += player.points + player.result_against(oponent).value

    return score


def part2(game: Game[PlayerResult]) -> int:
    score = 0
    for oponent, result in game:
        score += result.points + result.necessary_shape_against(oponent).value

    return score


def solution(input: str) -> tuple[int, int]:
    return (
        part1(parse_game(input, PlayerShape)),
        part2(parse_game(input, PlayerResult)),
    )

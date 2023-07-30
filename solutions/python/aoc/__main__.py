import sys
from argparse import ArgumentParser
from importlib import import_module
from pathlib import Path
from typing import NoReturn


def fail(message: str, code=1) -> NoReturn:
    print(message, file=sys.stderr)
    exit(code)


def cli() -> ArgumentParser:
    parser = ArgumentParser("aoc", description="Advent of Code Python solutions")
    parser.add_argument("year", help="Advent of Code year", type=int)
    parser.add_argument("day", help="Advent of Code day", type=int)
    parser.add_argument("input", help="Path to alternate input", type=Path, nargs="?")

    return parser


def main():
    args = cli().parse_args()

    if args.input is None:
        base_dir = Path(__file__).parents[3]
        args.input = base_dir / "inputs" / str(args.year) / f"day{args.day:02d}.txt"

    try:
        module = import_module(f"aoc.year{args.year}.day{args.day:02d}")
    except ModuleNotFoundError as e:
        fail(f"Solution for year {args.year} day {args.day} not found: {str(e)}")

    try:
        solution = getattr(module, "solution")
    except AttributeError:
        fail(f"Module {module.__name__} doesn't contain the 'solution' function")

    try:
        with open(args.input) as f:
            input = f.read()
    except Exception as e:
        fail(f"Could not read input file: {str(e)}")

    part1, part2 = solution(input)

    print(f"{part1}\n{part2}")


if __name__ == "__main__":
    main()

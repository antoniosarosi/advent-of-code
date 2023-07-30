def parse_total_calories(input: str) -> list[int]:
    return [sum(map(int, elf.split())) for elf in input.strip().split("\n\n")]


def part1(calories: list[int]) -> int:
    return max(calories)


# O(n log n)
# def part2(calories: list[int]) -> int:
#     return sum(sorted(calories, reverse=True)[:3])


# O(n)
def part2(calories: list[int]) -> int:
    top_three = [0, 0, 0]
    for cal in calories:
        for i in range(len(top_three)):
            if cal > top_three[i]:
                for j in range(2, i, -1):
                    top_three[j] = top_three[j - 1]
                top_three[i] = cal
                break

    return sum(top_three)


def solution(input: str) -> tuple[int, int]:
    calories = parse_total_calories(input)

    return part1(calories), part2(calories)

use std::num::ParseIntError;

use crate::{PartSolver, ProblemSolver};

fn parse_total_calories(input: &str) -> Vec<i32> {
    let calories: Result<Vec<i32>, ParseIntError> = input
        .trim()
        .split("\n\n")
        .map(|elf| elf.split("\n").map(|cal| cal.parse::<i32>()).sum())
        .collect();

    calories.expect("Parse error")
}

fn part1(calories: &Vec<i32>) -> i32 {
    *calories.iter().max().expect("part1(): Empty list")
}

// O(n log n)
// fn part2(calories: &Vec<i32>) -> i32 {
//     let mut calories = calories.to_owned();
//     calories.sort_by(|a, b| b.cmp(a));
//     calories.iter().take(3).sum()
// }

// O(n)
fn part2(calories: &Vec<i32>) -> i32 {
    let mut top_three = [0, 0, 0];
    for cal in calories {
        for i in 0..top_three.len() {
            if *cal > top_three[i] {
                for j in (i + 1..=2).rev() {
                    top_three[j] = top_three[j - 1];
                }
                top_three[i] = *cal;
                break;
            }
        }
    }

    top_three.iter().sum()
}

pub(crate) fn solution() -> ProblemSolver {
    ProblemSolver::new(
        PartSolver(parse_total_calories, part1),
        PartSolver(parse_total_calories, part2),
    )
}

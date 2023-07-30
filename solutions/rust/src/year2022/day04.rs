use std::ops::RangeInclusive;

use crate::{PartSolver, ProblemSolver};

type Pair = (RangeInclusive<u32>, RangeInclusive<u32>);

fn parse_range(input: &str) -> RangeInclusive<u32> {
    let [start, end] = input.split("-").next_chunk().unwrap();

    RangeInclusive::new(
        start.parse().expect(&format!("parse_range(): {input}")),
        end.parse().expect(&format!("parse_range(): {input}")),
    )
}

fn parse(input: &str) -> Vec<Pair> {
    let assignments = input.lines().map(|line| {
        let [first_elf, second_elf] = line.split(",").next_chunk().unwrap();
        (parse_range(first_elf), parse_range(second_elf))
    });

    assignments.collect()
}

fn count_pairs(assignments: &Vec<Pair>, predicate: impl FnMut(&&Pair) -> bool) -> i32 {
    assignments.iter().filter(predicate).count() as i32
}

// Part 1
trait FullyContains {
    fn fully_contains(&self, other: &Self) -> bool;
}

impl<T: Ord> FullyContains for RangeInclusive<T> {
    fn fully_contains(&self, other: &Self) -> bool {
        other.start() >= self.start() && other.end() <= self.end()
    }
}

fn part1(assignments: &Vec<Pair>) -> i32 {
    count_pairs(assignments, |(first_elf, second_elf)| {
        first_elf.fully_contains(second_elf) || second_elf.fully_contains(first_elf)
    })
}

// Part 2
trait Overlaps {
    fn overlaps(&self, other: &Self) -> bool;
}

impl<T: Ord> Overlaps for RangeInclusive<T> {
    fn overlaps(&self, other: &Self) -> bool {
        other.contains(&self.start()) || other.contains(&self.end())
    }
}

fn part2(assignments: &Vec<Pair>) -> i32 {
    count_pairs(assignments, |(first_elf, second_elf)| {
        first_elf.overlaps(second_elf) || second_elf.overlaps(first_elf)
    })
}

pub(crate) fn solution() -> ProblemSolver {
    ProblemSolver::new(PartSolver(parse, part1), PartSolver(parse, part2))
}

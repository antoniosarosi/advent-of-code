use std::collections::HashSet;

use crate::{PartSolver, ProblemSolver};

const GROUP_SIZE: usize = 3;

type Item = char;
type Rucksack = (Vec<Item>, Vec<Item>);
type Group = [Rucksack; GROUP_SIZE];

fn parse(input: &str) -> Vec<Group> {
    input
        .trim()
        .lines()
        .array_chunks::<GROUP_SIZE>()
        .map(|chunk| {
            chunk.map(|line| {
                let half = line.len() / 2;
                let first_compartment = line[..half].chars();
                let second_compartment = line[half..].chars();
                (first_compartment.collect(), second_compartment.collect())
            })
        })
        .collect()
}

fn priority(item: Item) -> usize {
    let index = ('a'..='z').chain('A'..='Z').position(|c| c == item);
    index.expect(&format!("invalid item: {item}")) + 1
}

fn ruckcask_into_hash_set(ruckcask: &Rucksack) -> HashSet<Item> {
    HashSet::from_iter(ruckcask.0.iter().chain(ruckcask.1.iter()).copied())
}

fn part1(rucksacks: &Vec<Rucksack>) -> i32 {
    let priorities = rucksacks.iter().map(|rucksack| {
        let first_compartment = HashSet::<Item>::from_iter(rucksack.0.iter().copied());

        let duplicate = rucksack
            .1
            .iter()
            .find(|item| first_compartment.contains(item))
            .expect("no duplicate item found");

        priority(*duplicate)
    });

    priorities.sum::<usize>() as i32
}

fn part2(groups: &Vec<Group>) -> i32 {
    let priorities = groups.iter().map(|group| {
        let mut candidates = ruckcask_into_hash_set(&group[0]);

        group[1..]
            .iter()
            .map(ruckcask_into_hash_set)
            .for_each(|rucksack| candidates.retain(|item| rucksack.contains(item)));

        priority(*candidates.iter().next().expect("no repeated item found"))
    });

    priorities.sum::<usize>() as i32
}

pub(crate) fn solution() -> ProblemSolver {
    ProblemSolver::new(
        PartSolver(
            |input: &str| parse(input).clone().into_iter().flatten().collect(),
            part1,
        ),
        PartSolver(parse, part2),
    )
}

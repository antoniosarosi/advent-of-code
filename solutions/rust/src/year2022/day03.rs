use std::collections::HashSet;

const GROUP_SIZE: usize = 3;

type Item = char;
type Rucksack = Vec<Item>;
type Group = [Rucksack; GROUP_SIZE];

fn parse(input: &str) -> Vec<Group> {
    input
        .trim()
        .lines()
        .array_chunks::<GROUP_SIZE>()
        .map(|chunk| chunk.map(|line| line.chars().collect()))
        .collect()
}

/// O(1) but "slow"
#[allow(dead_code)]
fn priority_linear(item: Item) -> usize {
    let index = ('a'..='z').chain('A'..='Z').position(|c| c == item);
    index.expect(&format!("invalid item: {item}")) + 1
}

/// Faster O(1)
fn priority(item: Item) -> usize {
    let lower_case_shift = (b'a' - 1) as usize;
    let upper_case_shift = (b'A' - 2) as usize;
    let letter_count = (b'z' - b'a') as usize;

    match item {
        'a'..='z' => item as usize - lower_case_shift,
        'A'..='Z' => item as usize - upper_case_shift + letter_count,
        _ => panic!("invalid item: {item}"),
    }
}

fn part1(rucksacks: &Vec<Rucksack>) -> usize {
    let priorities = rucksacks.iter().map(|rucksack| {
        let half = rucksack.len() / 2;
        let first_compartment = HashSet::<Item>::from_iter(rucksack[..half].iter().copied());
        let duplicate = rucksack[half..]
            .iter()
            .find(|item| first_compartment.contains(item))
            .expect("no duplicate item found");

        priority(*duplicate)
    });

    priorities.sum()
}

fn part2(groups: &Vec<Group>) -> usize {
    let priorities = groups.iter().map(|group| {
        let mut candidates = HashSet::<Item>::from_iter(group[0].iter().copied());

        group[1..]
            .iter()
            .map(|group| HashSet::<Item>::from_iter(group.iter().copied()))
            .for_each(|rucksack| candidates.retain(|item| rucksack.contains(item)));

        priority(*candidates.iter().next().expect("no repeated item found"))
    });

    priorities.sum()
}

pub(crate) fn solution(input: &str) -> (String, String) {
    let rucksacks = parse(input);

    return (
        part1(&rucksacks.clone().into_iter().flatten().collect()).to_string(),
        part2(&rucksacks).to_string(),
    );
}

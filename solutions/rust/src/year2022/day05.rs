use std::str::FromStr;

#[derive(Debug)]
struct Move {
    ammount: usize,
    from: usize,
    to: usize,
}

impl FromStr for Move {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut parts = s.split_whitespace();

        let [_, amount] = parts.next_chunk().unwrap();
        let [_, from] = parts.next_chunk().unwrap();
        let [_, to] = parts.next_chunk().unwrap();

        Ok(Move {
            ammount: amount.parse().unwrap(),
            from: from.parse::<usize>().unwrap() - 1,
            to: to.parse::<usize>().unwrap() - 1,
        })
    }
}

fn parse(input: &str) -> (Vec<Vec<char>>, Vec<Move>) {
    let [initial_stacks, rearrangements] = input.trim_end().split("\n\n").next_chunk().unwrap();

    let rearrangements = rearrangements
        .lines()
        .map(|line| line.parse::<Move>())
        .collect::<Result<Vec<Move>, String>>()
        .unwrap();

    let mut iter_stacks = initial_stacks.lines().rev();
    let number_of_stacks = iter_stacks.next().unwrap().split_whitespace().count();

    let mut stacks = Vec::with_capacity(number_of_stacks);
    for _ in 0..number_of_stacks {
        stacks.push(Vec::new());
    }

    for mut row in iter_stacks.map(|row| row.chars()) {
        let mut current_stack = 0;
        while let Ok([bracket, marked_crate, _]) = row.next_chunk::<3>() {
            if bracket == '[' {
                stacks[current_stack].push(marked_crate);
            }
            row.next();
            current_stack += 1;
        }
    }

    (stacks, rearrangements)
}

fn top_crates(stacks: &Vec<Vec<char>>) -> Vec<char> {
    stacks.iter().map(|stack| *stack.last().unwrap()).collect()
}

fn part1(stacks: &mut Vec<Vec<char>>, instructions: &Vec<Move>) -> Vec<char> {
    for instruction in instructions {
        for _ in 0..instruction.ammount {
            let marked_crate = stacks[instruction.from].pop().unwrap();
            stacks[instruction.to].push(marked_crate);
        }
    }

    top_crates(stacks)
}

fn part2(stacks: &mut Vec<Vec<char>>, instructions: &Vec<Move>) -> Vec<char> {
    let mut queue = Vec::new();
    for instruction in instructions {
        for _ in 0..instruction.ammount {
            queue.push(stacks[instruction.from].pop().unwrap());
        }
        for marked_crate in queue.iter().rev() {
            stacks[instruction.to].push(*marked_crate);
        }
        queue.clear();
    }

    top_crates(stacks)
}

pub(crate) fn solution(input: &str) -> (i32, i32) {
    let (mut stacks, instructions) = parse(input);

    let part1 = String::from_iter(part1(&mut stacks.clone(), &instructions));
    let part2 = String::from_iter(part2(&mut stacks, &instructions));

    println!("{part1}\n{part2}");
    (0, 0)
}

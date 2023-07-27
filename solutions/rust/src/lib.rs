#![feature(iter_array_chunks)]
#![feature(iter_next_chunk)]

mod year2022;

use std::collections::HashMap;

type Solution = fn(&str) -> (i32, i32);

pub fn collect_solutions<'a>() -> HashMap<&'a str, Solution> {
    HashMap::from([
        ("2022/01", year2022::day01::solution as Solution),
        ("2022/02", year2022::day02::solution),
        ("2022/03", year2022::day03::solution),
        ("2022/04", year2022::day04::solution),
    ])
}

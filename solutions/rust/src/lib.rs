mod year2022;

use std::collections::HashMap;

type Solution = fn(&str) -> (i32, i32);

pub fn collect_solutions<'a>() -> HashMap<&'a str, Solution> {
    HashMap::from([
        ("2022/01", year2022::day01::solution as Solution),
        ("2022/02", year2022::day02::solution),
    ])
}

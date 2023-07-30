#![feature(iter_array_chunks)]
#![feature(iter_next_chunk)]

mod year2022;

use std::{
    collections::HashMap,
    fmt::Display,
    time::{Duration, Instant},
};

/// Each AoC problem has 2 parts. Each part takes an input and returns a number.
/// This struct is basically like a pipe in the form of `input -> parse -> solve`.
pub(crate) struct PartSolver<T>(fn(&str) -> T, fn(&T) -> i32);

/// We want to know how long it takes to parse and solve each individual problem
/// part, so we'll store that information in this struct.
pub struct PartSolution {
    parsing_time: Duration,
    solving_time: Duration,
    solution: i32,
}

/// Since [`PartSolver`] is generic and we want to store all the solutions in
/// a map for easy lookups, we are going to implement a trait for [`PartSolver`]
/// that returns a [`PartSolution`]. This allows us to use dynamic dispatch.
pub trait SolvePart {
    /// Takes an AoC problem `input` and computes the necessary time it takes
    /// to parse it and solve the problem.
    fn solve(&self, input: &str) -> PartSolution;
}

impl<T> SolvePart for PartSolver<T> {
    fn solve(&self, input: &str) -> PartSolution {
        let Self(parse, solve) = self;

        let mut now = Instant::now();
        let data = parse(input);
        let parsing_time = now.elapsed();

        now = Instant::now();
        let solution = solve(&data);
        let solving_time = now.elapsed();

        PartSolution {
            parsing_time,
            solving_time,
            solution,
        }
    }
}

impl Display for PartSolution {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "- Parsing Time: {:?}\n", self.parsing_time)?;
        write!(f, "- Solving Time: {:?}\n", self.solving_time)?;
        write!(f, "- Solution: {}\n", self.solution)
    }
}

/// As we mentioned before (see [`PartSolver`]) each AoC problem has 2 parts.
/// We'll store a couple pointers to the underlying [`PartSolver`] in this tuple
/// struct.
pub struct ProblemSolver(pub Box<dyn SolvePart>, pub Box<dyn SolvePart>);

impl ProblemSolver {
    /// Shorthand to avoid boxing [`PartSolver`] structs all the time.
    fn new<P1: 'static, P2: 'static>(part1: PartSolver<P1>, part2: PartSolver<P2>) -> Self {
        Self(Box::new(part1), Box::new(part2))
    }
}

/// Finally, a solution is a function that returns a [`ProblemSolver`].
type Solution = fn() -> ProblemSolver;

/// Collects all the implemented solutions in a map.
pub fn collect_solutions<'a>() -> HashMap<&'a str, Solution> {
    HashMap::from([
        ("2022/01", year2022::day01::solution as Solution),
        ("2022/02", year2022::day02::solution),
        ("2022/03", year2022::day03::solution),
        ("2022/04", year2022::day04::solution),
    ])
}

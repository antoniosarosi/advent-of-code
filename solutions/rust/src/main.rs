use clap::Parser;

#[derive(Parser, Debug)]
#[command(name = "aoc-rs")]
/// Advent of Code Rust CLI
struct Cli {
    /// Advent of Code year
    year: u32,

    /// Advent of Code day
    day: u8,

    /// Alternate input file
    input: Option<std::path::PathBuf>,
}

fn main() -> std::io::Result<()> {
    let Cli { year, day, input } = Cli::parse();
    let solutions = rust::collect_solutions();

    let key = format!("{year}/{day:02}");

    let solution = solutions.get(key.as_str()).expect(&format!(
        "Solution for year {year} day {day} is not implemented"
    ));

    let input = input.unwrap_or(
        std::env::current_exe()?
            .ancestors()
            .nth(5)
            .expect("input file path is wrong. Use `cargo run`.")
            .join(format!("inputs/{year}/day{day:02}.txt")),
    );

    let (part1, part2) = solution(&std::fs::read_to_string(input)?);

    println!("{part1}\n{part2}");

    Ok(())
}

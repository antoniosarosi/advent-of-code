fn main() -> Result<(), String> {
    let args: Vec<String> = std::env::args().collect();

    if args.len() < 3 || args.len() > 4 {
        return Err(format!(
            "Usage: {} YEAR DAY [path/to/alternate/input.txt]",
            args[0]
        ));
    }

    let year = args[1]
        .parse::<u32>()
        .map_err(|err| format!("Can't parse year '{}': '{err}'", args[1]))?;

    let day = args[2]
        .parse::<u32>()
        .map_err(|err| format!("Can't parse day '{}': '{err}'", args[2]))?;

    let input_file = match args.get(3) {
        Some(path) => std::path::PathBuf::from(path),

        None => {
            let executable = std::env::current_exe()
                .map_err(|err| format!("Can't get executable path: {err}"))?;

            let root_directory = executable
                .ancestors()
                .nth(5)
                .ok_or("Executable file path is wrong. Use `cargo run`.")?;

            root_directory.join(format!("inputs/{year}/day{day:02}.txt"))
        }
    };

    let solutions = rust::collect_solutions();

    let solution = solutions
        .get(format!("{year}/{day:02}").as_str())
        .ok_or(format!(
            "Solution for year {year} day {day} is not implemented"
        ))?;

    let input = std::fs::read_to_string(&input_file)
        .map_err(|err| format!("Cannot read input file '{}': {err}", input_file.display()))?;

    let (part1, part2) = solution(&input);

    println!("{part1}\n{part2}");

    Ok(())
}

# Advent of Code

## Structure

- [`inputs`](./inputs/) My AoC inputs for each year and day.
- [`solutions`](./solutions/) My solutions divided by programming languages.

Each project in the [`solutions`](./solutions/) directory has a CLI tool that
can be used to execute any AoC solution from a single entry point (there's
only one `main` function). For example:

```bash
cd ./solutions/rust/

# Execute AoC Year 2022 Day 2 with the default input file
cargo run -- 2022 2

# Execute AoC Year 2022 Day 2 with an input file of your choice
cargo run -- 2022 2 ./some/other/input/file.txt
```

The rest of languages can do the same. Instructions for each specific language
can be found in their respective `README.md` file.

> [!NOTE]
> Input files must use `LF` only line endings (`\n`), **not** `CRLF` (`\r\n`)

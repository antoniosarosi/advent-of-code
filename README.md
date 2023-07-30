# Advent of Code

## Structure

- [`inputs`](./inputs/) My AoC inputs for each year and day.
- [`solutions`](./solutions/) My solutions divided by programming languages.

Each directory inside [`solutions`](./solutions/) is a package that contains
the code for each AoC year and day along with a CLI tool that can run specific
AoC problems. For example:

```
.
└── solutions/
    └── python/
        ├── __main__.py
        └── year2022/
            ├── day01.py
            └── day02.py
```

You can run the code as follows:

```bash
python solutions/python 2022 1
```

You can also provide alternate input files using an optional third argument:

```bash
python solutions/python 2022 1 ./path/to/alternate/input.txt
```

> [!NOTE]
> Note that input files must use `LF` only line endings (`\n`)

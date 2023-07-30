# C

Compile the program from the [`advent-of-code`](../../) root directory, not this
directory:

```bash
gcc ./solutions/c/src/main.c -o ./solutions/c/aoc
```

The inputs directory is defined as `"./inputs/"` in the program, so you should
run the binary from the [`advent-of-code`](../../) root as well:

```bash
./solutions/c/aoc 2022 1 ./optional/path/to/alternate/input.txt
```

You can also `#define` the inputs directory at compile time and run it from
anywhere:


```bash
cd ./solutions/c/
gcc -D INPUTS_DIR=\"$(pwd)/../../inputs/\" ./src/main.c -o aoc
./aoc 2022 1
```

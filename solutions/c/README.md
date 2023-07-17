# C

Compile the program from the root, not this directory:

```bash
gcc -D INPUTS_DIR=\"$(pwd)/inputs/\" solutions/c/src/main.c -o solutions/c/aoc
```

Then run it:

```bash
./solutions/c/aoc 2022 1 ./optional/path/to/alternate/input.txt
```

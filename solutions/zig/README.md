# Zig

Compile the binary from this directory:

```bash
cd ./solutions/zig/
zig build
```

Run it from the project root (because [`./inputs/`](./../../inputs/) is relative):

```bash
cd ../../
./solutions/zig/zig-out/bin/aoc 2022 1
```

Or just pass the file as an argument:

```bash
cd ./solutions/zig/
zig build
./zig-out/bin/aoc 2022 1 ../../inputs/2022/day01.txt
```

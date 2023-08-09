# Go

Build the go binary from its source code root and run it from the same place
because the inputs directory is assumed to be [`../../inputs`](../../inputs/)
by default:

```bash
cd solutions/go
go build ./cmd/cli/
./cli 2022 1 ./path/to/optional/input.txt
```

Alternatively, you can embed the full path of the inputs directory at compile
time so that you can run the binary from anywhere:

```bash
cd solutions/go
go build -ldflags "-X main.InputsDirectory=$(pwd)/../../inputs/" ./cmd/cli/
./cli 2022 1 ./path/to/optional/input.txt
```

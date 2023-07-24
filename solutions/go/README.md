# Go

Build the go binary from its source code root and go back to the project root
to run it (because [`../../inputs`](../../inputs/) directory is located there):

```bash
cd solutions/go
go build ./cmd/cli/

cd ../..
./solutions/go/cli 2022 1 ./path/to/alternate/input.txt
```

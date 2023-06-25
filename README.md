# random-pairs

## Building

```bash
make
# OR
make random-pairs
```

## Running
A symlink to the binary is created in the root of the package. The command can be run by calling the following from the root of the package.

```bash
./random-pairs
```

## Details
```
OVERVIEW: Tools for randomly pairing items together.

USAGE: random-pairs <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  generate                Generates a new set of random pairs weighted by how
                          recently they last paired.
  history                 Shows the previously generated set of pairs.
  participation           Track pair participation for the previously generated
                          set of pairs.
  stats                   Show stats for the previously generated sets of pairs.

  See 'random-pairs help <subcommand>' for detailed help.
```

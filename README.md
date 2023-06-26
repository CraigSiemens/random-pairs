# random-pairs

A set of tools for generating and tracking random pairs of items.

## Installation

### HomeBrew

```bash
brew install craigsiemens/tap/random-pairs
```

### Manually

```bash
make
# OR
make random-pairs
```

This will create a binary in `.build/release/random-pairs`. It will also create a symlink to the binary in the root of the package. The command can be run by calling the following from the root of the package.

## Configuration

This command reads from a `config.json` file. See [Config.swift](Sources/RandomPairs/Models/Config.swift) for all the possible options. 

By default it reads the file from `~/Library/Application Support/RandomPairs/config.json` but a custom path can be passed instead. On the first run of `random-pairs`, the file will be created if it doesn't already exist.

- `items` - An array of items to randomly create pairs from.
- `randomizationWeighting` - For controlling the weights to apply when generating pairs based on the number of iterations since they last paired.
  - `exponential` - Sets the weights to be `iterations * iterations` to greatly increase the chances that old pairs will be chosen before repeating a recent pair.
  - `linear` - Sets the weights to `iterations` to slightly increase the chances that old pairs will be chosen before repeating a recent pair.
  - `uniform` - Sets the weights to `1` so the history has no impact on the next pairs.
- `oddItemAppearance` - Controls what should be shown when there is an odd number of item to make pairs from. 
  - `{ "hidden": {} }` - Hides the remaining item after generating the pairs. 
  - `{ "shown": { "name": "[Some Name]" } }` - Shows the remaining item as being paired with the provided name.

## Details
```
OVERVIEW: Tools for randomly pairing items together.

USAGE: random-pairs <subcommand>

OPTIONS:
  --version               Show the version.
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

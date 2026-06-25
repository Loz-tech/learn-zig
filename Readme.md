### Learning about zig programming language via ziglings

Using wonderful ziglings https://codeberg.org/ziglings/exercises/ repo to learn about zig programming language

Rewriting examples from repo above and solving in parallel problems with code and learning the language :)

## Project structure

```
lean-zig/
├── build.zig          # Build script: defines `lean_zig` module, executable, test and run steps
├── build.zig.zon      # Package manifest (name: lean_zig, min Zig 0.16.0)
├── Readme.md          # This file
├── src/
│   ├── root.zig       # Library root: public `printAnotherMessage`, `add`
│   ├── main.zig       # CLI entrypoint: stdout writer, args, fuzz test
│   └── exercices/     # Numbered exercise solutions (001-058)
│       ├── 001_hello.zig
│       ├── 002_std.zig
│       ├── ...
│       └── 058_quiz.zig
├── exercises/         # (empty) scratch dir for experiments
├── ziglings/          # Vendored upstream ziglings repo (gitignored, reference only)
├── zig-out/           # Build output (gitignored)
├── 002_std            # Stray built binary (gitignored)
└── 003_assignment     # Stray built binary (gitignored)
```

## Exercises

Numbered solutions in `src/exercices/`, rewritten from ziglings and solved locally:

| Range | Topic |
|-------|-------|
| 001-003 | hello, std, assignment |
| 004-008 | arrays, strings, quiz |
| 009-017 | if, while, for, quiz |
| 018-020 | functions, quiz |
| 021-025 | errors |
| 026-029 | hello, defer, errdefer |
| 030-034 | switch, unreachable, iferror, quiz |
| 035-036 | enums |
| 037-038 | structs |
| 039-044 | pointers, quiz |
| 045-046 | optionals |
| 047-050 | methods, quiz, no value |
| 051-054 | values, slices, many-pointers |
| 055-058 | unions, quiz |

## Commands

```sh
zig build           # Build the executable into zig-out/
zig build run       # Build and run the app
zig build test      # Run tests in root module and executable module
```

Pass runtime args with `zig build run -- arg1 arg2`.
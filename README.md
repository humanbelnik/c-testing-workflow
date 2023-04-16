# c-testing-workflow
:closed_lock_with_key: Automating process of testing c-labs
# Workflow
## Setup
Place this scripts in you workint directory with `*.c` files. Make sure that file organisation is the same as in this repository.
## Create data for testing with `make_stdin.sh`
`make_stdin.sh` - main script for data generation
`trimmer.sh` - subscript for trimming output. 
Script creates `func_tests/data/` folder with `pos` and `neg` test cases. 
After it shutted down by `q` it creates `readme.md` file in `func_tests/` directory with test's description.
##### Launch:
``` shell
$ ./make_stdin.sh [ -r | -s | -a ]
```
* You can use `|` as a delimiter while inputting your IN data. This symbol will be ignored.
* `-r` rebuilds your project with `build_release.sh`. Make sure that this script is in your working directory.
* `-s` trims output from `Result:` substring and further. Use it if your program gives string output. Script trims floating points from output by default.
* `-a` automates output generation. It will put your program's actual output in `_out.txt` files. Use it in simple cases in order to make your testing workflow faster.

## Test your program on your data with `func_tests.sh`
`func_tests.sh` - main script that accumulate testing stats by running `pos_case.sh` and `neg_case.sh`
##### Launch:
``` shell
$ ./func_tests.sh [ -v | -r | -s | -n ]
```
* `-v` - verbose mode. Gives your info about how many `negatives` and `positives` were passed
* `-r` - rebuilds your project with `build_release.sh`
* `-s` - uses `str_comparator.sh`
* `-n` - usues `num_comparator.sh`
* By default script uses `comaprartor.sh`

### Comparators
`num_comparator.sh` - comparing floating-point sequences from two files
`str_comparator.sh` - comparing symbol sequences after certain substing from two files. By default substring is `Result:`. You can change substring manually through code editing.
``` shell
$ ./<script_name> [ -v ]
```
* `-v` - verbose mode. Shows your which seuqences from files will be actually compared

### Cleaner
`sclean.sh` - main script cleaning working directory safely
`clean.sh` - subscript for actual cleaning
``` shell
$ ./sclean.sh
```

# P.S
* Scipts are adopted for multifile C projects
* Make sure that you end your C program's output with `\n`
* Script's code is a mess, but it works... What else we wnat from bash?

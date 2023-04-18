> The following group of scripts will allow you to comfotably test your C-language projects. 
# Workflow
## 1. Setup 
1. Copy this reposiory to your local machine 
    ``` bash
    git clone <repo/link>
    ```
2. You need to place your project files in `proj` folder. If you have multiple projects - copy `proj` folder as many times as you need, rename them and place your each of your project in each copied folder. At the end, your file structure shold be look like this:
    ```bash
    c-testing-workflow/
        /ctest
        /lab_XX_XX_XX
            main.c
            func_tests/
            *.sh
        /lab_YY_YY_YY
            main.c
            func_tests/
            *.sh
        ...
For the following steps we assume that our current directory is `proj` [Or any of you dirs that contains current C project]
## 2. Generate data with `make_stdin.sh`
```bash
$ ./make_stdin.sh [-r|-a|-s]
```
* `-r` runs `build_release.sh` in order to get the newest project version
* `-a` generates output automatically by redirecting STDOUT from `*.exe` to the test `*_out.txt` file
* `-s` trims STDOUT by ignoring all symbols before `Result:` substring
    * By default script trims the floating point numbers
---
#### After shutting down by `q` command you'll have:
1. All your test data-pairs like `pos_01_in.txt - pos_01_out.txt` in `./func_tests/data/`
2. `readme.md` file with all your tests descriptions in ./func_tests/
3. `.report.json` file with statistics for your tests [passed or not] in `./func_tests/data/`

## 3. Check statistics with `ctest`
```bash
$ ctest <proj_folder_name>
```

## 4. Builders
`build_release.sh`
`build_debug.sh`
`build_debug_asan.sh` -- address sanitizer
`build_debug_msan.sh` -- memory sanitizer
`build_debug_ubsan.sh` -- undefined behavior sanitizer

```bash
$ build_*.sh
```
## 5. Cleaner
`sclean.sh` - clean your directory
```bash
$ sclean.sh
```
## Note:
1. Multifile C-projects supported
2. It's not recommended to make data without `make_stdin.sh`. If you do so, you'll need to manually write data to readmes and launching `./func_tests/scripts/func_tests.sh` from `proj` folder`
3. Scripts are mess. Code is full of garbage from previous fixes. But it works. What else
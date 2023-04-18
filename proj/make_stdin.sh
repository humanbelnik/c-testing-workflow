#!/bin/bash

print_usage()
{
    printf "Usage: ./make_data.sh\n [-r] -- rebuild release version\n [-a] -- automate output\n [-s] -- trim stdout after 'Result:'\n"
}

# Define script behavior
flag_auto=""
flag_rebuild=""
flag_trimmer="-n"

while getopts "ars" flag; do
    case "$flag" in 
    a) flag_auto="true" ;;
    r) flag_rebuild="true" ;;
    s) flag_trimmer="-s" ;;
    *) print_usage
        exit 1
        ;;
    esac
done

# Rebuild project
if [ -n "$flag_rebuild" ] && [ -f "./build_release.sh" ]; then
    ./build_release.sh
    chmod +x main.exe
elif [ -n "$flag_rebuild" ] && [ ! -f "./build_release.sh" ]; then
    printf "[ERR]: build_release.sh not found."
    exit 1
fi

# Prepare files for data && report
data_folder="./func_tests/data"
readme_main="./func_tests/data/readme.md"
readme_ok="./func_tests/data/readme_ok.md"
readme_err="./func_tests/data/readme_err.md"

if [ ! -d "$data_folder" ]; then
  mkdir func_tests/data
fi

if [ ! -f "$readme_main" ]; then
  touch func_tests/data/readme.md
fi

if [ ! -f "$readme_ok" ]; then
  touch func_tests/data/readme_ok.md
  echo "# Positive cases:" > "$readme_ok"
fi

if [ ! -f "$readme_err" ]; then
  touch func_tests/data/readme_err.md
  echo "# Negative cases: " > "$readme_err"
fi

# Build STDIN
flag_on="true"
while [ "$flag" != "false" ]; do
    # Ask user option
    printf "Choose option:\n[pos] - Create positive data-pair\n[neg] - Create negative data-pair\n[q] - Quit.\n"
    read -p "Choice [pos/neg/q]? : " userChoice

    # User's choice validation
    if [ "$userChoice" != "pos" ] && [ "$userChoice" != "neg" ] && [ "$userChoice" != "q" ]; then
    pritnf "[ERR] : INCORRECT INPUT"
    continue
    fi

    # Shutting down
    if [ "$userChoice" == "q" ]; then
    cat "$readme_ok" > "$readme_main"
    cat "$readme_err" >> "$readme_main"
    cp "$readme_main" ./func_tests
    flag="false"

    # Launch functional testing to update JSON
    ./func_tests/scripts/func_tests.sh

    exit 0
    fi

    # Setup files dependin on users choice
    if [ "$userChoice" == "pos" ]; then
    count_old=$(find func_tests/data -type f -name "pos*in.txt" | wc -l)
    count_old=$(sed "s/ //g" <<< "$count_old")
    count=$((count_old + 1))
    file_prefix="pos_"
    data_status="positive"
    readme_file="$readme_ok"

    elif [ "$userChoice" == "neg" ]; then
    count_old=$(find func_tests/data -type f -name "neg*in.txt" | wc -l)
    count_old=$(sed "s/ //g" <<< "$count_old")
    count=$((count_old + 1))
    file_prefix="neg_"
    data_status="negative"
    readme_file="$readme_err"
    fi

    # Making data
    if [ "$count" -lt 10 ]; then
        count="0${count}"
    fi
    file_in="./func_tests/data/${file_prefix}${count}_in.txt"
    file_out="./func_tests/data/${file_prefix}${count}_out.txt"
    touch "$file_in"
    touch "$file_out"

    # Input
    read -p "Write a description for your ${count} ${data_status} test case: " description
    echo "### Test ${count} [${description}]" >> "$readme_file"
    read -p "Write input data for your ${count} ${data_status} test case: " data
    echo "$data" | sed -r 's/[|]+/ /g' > "$file_in"
    echo "- In:" >> "$readme_file"
    echo "$data" | sed -r 's/[|]+/ /g' >> "$readme_file"

    # Automative output
    if [ -n "$flag_auto" ]; then
        exe_file="./*.exe"
        $exe_file < "$file_in" > "$file_out"
        echo "$flag_trimmer"
        ./trimmer.sh "$flag_trimmer" "$file_out"
        echo "- Out:" >> "$readme_file"
        cat "$file_out" >> "$readme_file"
    else
        # Manual output
        read -p "Input out data for your ${count} ${data_status} test case: " out_data
        printf "%s\n" "$out_data" > "$file_out"
        echo "- Out: " >> "$readme_file"
        echo "$out_data" >> "$readme_file" 
    fi
done

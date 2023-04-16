#!/bin/bash

flag_str=""
flag_num=""
file=$2

while getopts "ns" flag; do
    case "$flag" in
    n) flag_num="-n" ;;
    s) flag_str="-s" ;;
    *) exit 1 ;;
    esac
done

touch /tmp/buffer
if [ "$flag_num" == "-n" ]; then
    echo "hello"
    regex="^[+-]?[0-9]+[.]?[0-9]*([e][+-]?[0-9]+)?$"
    while IFS= read -r line
        do
        for word in $line; do
            if [[ $word =~ $regex ]]; then
                echo "$word" >> /tmp/buffer
            fi
        done
    done < "$file"
    cat /tmp/buffer > "$file"
    rm /tmp/buffer
    exit 0
fi
cat "$file"
if [ "$flag_str" == "-s" ]; then
    string="Result:"
    flag=false
    echo "bye"
    while read -r line
    do
        if [ "$flag" = "true" ]; then
            echo "$line" >> /tmp/buffer
        else
            for word in $line; do
                if [[ $word =~ $string ]]; then
                    (sed -n -e "s/^.*\(Result:.*\)/\1/p" <<< "$line") > /tmp/buffer
                    flag=true
                    break
                fi
            done
        fi
    done < "$file"
    echo "buf"
    cat /tmp/buffer
    cat /tmp/buffer > "$file"
    rm /tmp/buffer
    exit 0
fi


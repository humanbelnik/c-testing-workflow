#!/bin/bash

print_verbose()
{
  printf "%s\n" "$1"
}

input_data=$1
output_data=$2

if [ -z "$input_data" -o -z "$output_data" ]; then
  echo "[ERR] I/O data-pair doesn't exist."
  exit 1
else
  # Define comparator
  if [ "$3" == "-s" ]; then
    comparator="../.././str_comparator.sh"
  elif [ "$3" == "-n" ]; then
    comparator="../.././num_comparator.sh"
  else
    comparator="../.././comparator.sh"
  fi

  if [ -n "$4" ]; then
    flag_verbose="-v"
  else
    flag_verbose=""
  fi

  test_num=$(echo "$input_data" | grep -o -E "[0-9]+")
  touch ../data/buffer_out.txt
  buffer="../data/buffer_out.txt"
  exe_file="../../main.exe"

  $exe_file < "$input_data" > "$buffer"
  return_code="$?"
  $comparator "$output_data" "$buffer" "$flag_verbose"

  pass=""
  if [ "$return_code" == "0" ]; then
    pass="OK"
    if [ -n "$flag_verbose" ]; then
      print_verbose "Positive test ${test_num} : PASS"
      exit 0
    fi
  else
    pass="FAIL"
    if [ -n "$flag_verbose" ]; then
      print_verbose "Positive test ${test_num} : FAIL"
      exit 1
    fi

  fi

  # Collect logs using logger.sh for statistics
  logger=../../logger.sh
  $logger "$input_data" "$return_code" "$pass" "pos"
fi


#!/bin/bash

# Define parameters
file_name=$1
return_code=$2
status=$3
test_type=$4
readme=""

# Make data
if [ "$test_type" == "pos" ]; then
    readme=../data/readme_ok.md 
else
    readme=../data/readme_err.md
fi
number=$(echo "$file_name" | grep -o -E "[0-9][0-9]")
description=""
if [ ! -f "$readme" ]; then
    description="None"
else
    description=$(grep "### Test ${number}" $readme)
    description=$(echo "$description" | awk '{for(i=4;i<=NF;i++) printf "%s ", $i}')
fi

json=../../.report.json
json_string=$(
  jq --null-input \
    --arg Number "${number}" \
    --arg Test_type "${test_type}" \
    --arg Description "${description}" \
    --arg Code "${return_code}" \
    --arg Status "${status}" \
    '$ARGS.named'
)

echo "$json_string" >> $json

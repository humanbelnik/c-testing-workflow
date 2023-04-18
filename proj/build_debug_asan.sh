#!/bin/bash

SRC_FILES=$(find . -maxdepth 1 -type f -name '*.c')
FLAGS="-std=c99 -fsanitize=address -fno-omit-frame-pointer -g3 -O0"

# Check if there're any source files
if [ -z "$SRC_FILES" ]; then
  echo "[ERR]: Directory doesn't contain any source files"
  exit 1
fi

# Compilation
for src_file in "${SRC_FILES}"; do
  if gcc ${FLAGS} -c ${src_file}; then
    echo "[OK]: project succesfully compiled"
  else
    echo "[ERR]: project can't be compiled"
    exit 1
  fi
done

# Linking
OBJ_FILES=$(find . -maxdepth 1 -type f -name '*.o')
if gcc -o main.exe ${OBJ_FILES}; then
  echo "[OK]: project linked succesfully."
else
    echo "[ERR]: unable to link project"
    exit 1
fi
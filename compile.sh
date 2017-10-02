#!/bin/sh

if [ "$#" -eq 0 ] || ! [ -f "$1" ]; then
    echo "Pass file name as first argument.";
    exit 1;
fi

BASENAME=$(basename "$1")
EXTENSION="${BASENAME##*.}"
FILE="${BASENAME%.*}"

if [ "$EXTENSION" != "asm" ]; then
    echo "File must have .asm extension.";
    exit 1;
fi

(nasm -f elf -F dwarf -g $FILE.asm && ld -m elf_i386 -o $FILE $FILE.o && chmod u+x $FILE)

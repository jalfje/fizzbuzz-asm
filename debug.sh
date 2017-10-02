#!/bin/sh

if [ "$#" -eq 0 ] || ! [ -f "$1" ]; then
    echo "Pass executable file name as first argument.";
    exit 1;
fi

 (gdb -q --ex="break *_start" --ex=run $1)

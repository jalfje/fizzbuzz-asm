# FizzBuzz-asm

A basic [FizzBuzz](https://en.wikipedia.org/wiki/Fizz_buzz) program written in Intel x86 assembly. This was the first thing I wrote in asm, so it's pretty basic. It should also be fairly well-commented to help me keep track of things, so it could be helpful for anyone interested in learning a bit of asm.

Created on Lubuntu 17.04, compiled with [nasm](http://www.nasm.us/), and debugged with [GDB](https://www.gnu.org/software/gdb/). To try it yourself, clone the repo, cd to the repo directory, and run:

    $ chmod u+x ./compile.sh
    $ ./compile.sh fizzbuzz.asm

which gives executable permissions to `compile.sh` then compiles fizzbuzz and gives the resulting `fizzbuzz` file executable permissions. To debug using GDB, run:

    $ chmod u+x ./debug.sh
    $ ./debug.sh fizzbuzz

which gives executable permissions to `debug.sh` then runs the executable in GDB, with a breakpoint set at the very first entry point. To step through, simply enter the `step` command once, then keep pressing enter.

If anyone wants to, feel free to send me an email about the project at jamiestm9@hotmail.com.

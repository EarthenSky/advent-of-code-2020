# advent-of-code-2020
 Solutions to advent of code 2020 puzzles

### Directories:
- src_decaf/ -> programs written using the decaf programming language as described here: http://anoopsarkar.github.io/compilers-class/decafspec.html
- src_python/ -> using python version 3.7
- src_cs/ -> c# using mono 6.12 on windows 10
- src_lua/ -> luajit 2.1.0-beta3 on debian wsl
- src_brainfuck/ -> https://copy.sh/brainfuck/ with default configuration (30000 memory size, 8-bit cell size, and no change EOF)
- src_haskell/ -> ghc 8.4.4 on debian wsl
- src_rust/ -> builds are run with cargo 1.48.0 on wsl debian
- src_matlab_octave/ -> presents solutions in both matlab R2020b & octave (this is b/c matlab is not open sourced, but I need to learn it for school)

### Sub-goals:
In addition to trying to solve all of the puzzles within 2020, my sub goals are (in order of importance):
- 1. to make every solution run consistently in less than a second on my computer (8 3.6ghz cores, nvidea 960 gpu).
- 2. to make every solution as simple as possible
- 3. to make every solution as small as possible

<br>
<br>

##### Decaf Side Note:
I'm currently not able to make my decaf compiler public, however it should be relatively trivial to convert those programs into a C-like language.
If you're honestly interested in this version of decaf (why?) you can find more information here: https://github.com/anoopsarkar/compilers-class-hw

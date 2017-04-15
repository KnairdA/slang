# slang

…a experimental Forth-like stack language implemented in D.

## Example

	1 i $
	§ incr dup @ 1 + swp $ ;
	§ print @ . pop ;
	§ withinBounds @ 10 < ;
	§ loop i withinBounds if i print i incr loop then else ;
	loop

The above _slang_ code to be entered in the repl prints the numbers from 1 to 9. The repl may be compiled and executed using `dub run` in the project directory.

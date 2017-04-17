# slang

…a experimental Forth-like stack language implemented in D.

## Example

	1 i $
	§ incr dup @ 1 + swp $ ;
	§ print @ . pop ;
	§ withinBounds @ 10 < ;
	§ loop i withinBounds if i print i incr loop then else ;
	loop

The above _slang_ code to be entered in the repl prints the numbers from 1 to 9. The repl may be compiled and executed using `dub run` in the project directory. Check the `example` directory for further further demonstrations.

## Words

Currently implemented primitives:

| Word                 | Description                                              |
| ---                  | ---                                                      |
| `§`                  | Custom word definition                                   |
| `$`, `@`             | Single token variable binding, resolution                |
| `if`, `then`, `else` | Conditional primitives                                   |
| `+`, `*`, `/`, `%`   | Common artithmetics                                      |
| `.`                  | Non destructive printing of top-of-stack                 |
| `pop`                | Remove uppermost stack element                           |
| `dup`                | Duplicate top-of-stack                                   |
| `swp`                | Swap the first two stack elements                        |
| `over`               | Place a copy of the second stack element on top-of-stack |
| `rot`                | Rotate the top three stack elements                      |
| `true`               | Write true boolean value to top-of-stack                 |
| `false`              | Write false boolean value to top-of-stack                |
| `!`                  | Negate boolean value                                     |
| `<`                  | Compare size of two integers                             |
| `=`                  | Compare equality of two stack values                     |
| `&`                  | Boolean and                                              |
| `or`                 | Boolean or                                               |
| `#`                  | Debug word printing the whole stack to _stdout_          |

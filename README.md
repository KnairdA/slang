# slang

…is a experimental Forth-like stack language implemented in D.

## Example

```
1 i $

§ incr dup @ 1 + swp $ ;
§ withinBounds @ 100 < ;

§ fizz? @ 3 % 0 = ;
§ buzz? @ 5 % 0 = ;

§ fizzbuzz_or_fizz     buzz? if fizzbuzz then fizz else . pop ;
§ buzz_or_print    dup buzz? if pop buzz then @    else . pop ;

§ branch dup fizz? if fizzbuzz_or_fizz then buzz_or_print else ;

§ loop i withinBounds if i branch i incr loop then else ;

loop
```

This listing implements the common _FizzBuzz_ example in _slang_. It may be executed by compiling the REPL using `dub build` in the project directory and running `./slang example/fizzbuzz.slang`.

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
| `ovr`                | Place a copy of the second stack element on top-of-stack |
| `rot`                | Rotate the top three stack elements                      |
| `true`               | Write true boolean value to top-of-stack                 |
| `false`              | Write false boolean value to top-of-stack                |
| `not`                | Negate boolean value                                     |
| `and`                | Boolean and                                              |
| `or`                 | Boolean or                                               |
| `<`                  | Compare size of two integers                             |
| `=`                  | Compare equality of two stack values                     |
| `#`                  | Debug word printing the whole stack to _stdout_          |

Further words are implemented in `library/base.slang`.

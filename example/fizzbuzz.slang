1 i $

§ incr dup @ 1 + swp $ ;
§ withinBounds @ 100 < ;

§ fizz? @ 3 % 0 = ;
§ buzz? @ 5 % 0 = ;

§ fizzbuzz_or_fizz     buzz? if fizzbuzz then fizz else . pop ;
§ buzz_or_print    dup buzz? if buzz     then @    else . pop ;

§ branch dup fizz? if fizzbuzz_or_fizz then buzz_or_print else ;

§ loop i withinBounds if i branch i incr loop then else ;

loop

1 i $

§ incr dup @ 1 + swp $ ;
§ print @ . pop ;
§ withinBounds @ 10 < ;

§ loop i withinBounds if i print i incr loop then else ;

loop

§ nip  swp pop ;
§ tuck swp ovr ;

§ abs dup 0 < if -1 * then else ;

§ min ovr ovr < if     pop then swp pop else ;
§ max ovr ovr < if swp pop then     pop else ;

§ >  swp < ;
§ <= > not ;
§ >= < not ;

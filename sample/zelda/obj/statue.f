create-type `statue

( shoot shit at link )
: /shit  draw> 8 8 +at rndcolor 4 circlef ;
: (limit)  act> in-playfield? not ?end ;
: (snipe)  p1 perform> 30 pauses toward 1.5 dup 2* vx 2! ;
: snipe  { me from spawn /shit (limit) (snipe) } ;

`statue :to start  ['] snipe 270 every ;


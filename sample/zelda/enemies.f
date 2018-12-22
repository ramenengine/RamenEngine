var hp  2 defaults 's hp !
var damaged  \ stores the attack power of the last call to -HP
var startx  var starty
action die ( - )
basis :to die ( - ) end ;

: !startxy x 2@ startx 2! ;
: rndcolor  1 rnd 1 rnd 1 rnd rgb ;    

( damage )
: -hp  ( n - )  dup negate hp +! damaged ! hp @ ?exit die ;
: undamage  damaged off ;
: damage  ( n obj - )
    >{ damaged @ if drop } ;then -hp ['] undamage 60 after } ;

( interactions )
: ~weapons  
    with stage each> as #weapon hit? if 1 you damage then 
;

( shoot shit at link )
: /shit  draw> 2 2 +at rndcolor 4 circf ;
: (snipe)  act> in-playfield? not ?end ;
: snipe  { me from spawn /shit p1 toward 1.5 dup 2* vx 2! (snipe) } ;

( blue orb thing )
: orbit  !startxy perform> 0 begin dup 16 vec startx 2@ 2+ x 2! over + pause again ;
: /orb  draw> 8 8 +at  pixalign  8 8 damaged @ if rndcolor else blue then circf ;
: *orb  spawn /orb -5 orbit act> ~weapons ;

( stone statue )
: *statue  spawn /orb ['] snipe 270 every ;


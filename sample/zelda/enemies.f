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
: /shit  draw> 8 8 +at pixalign rndcolor 4 circf ;
: (limit)  act> in-playfield? not ?end ;
: (snipe)  p1 perform> 30 pauses toward 1.5 dup 2* vx 2! ;
: snipe  { me from spawn /shit (limit) (snipe) } ;

( blue orb thing )
: orbit  !startxy perform> 0 begin dup 16 vec startx 2@ 2+ x 2! over + pause again ;
: /orb  draw> 8 8 +at  pixalign  8 8 damaged @ if rndcolor else blue then circf ;
: *orb  spawn /orb -5 orbit act> ~weapons ;

( stone statue )
: *statue  spawn /orb ['] snipe 270 every ;

( test enemy )
s" enemy-icon.png" >data image: enemy-icon.image
: /test  draw> damaged @ frmctr 1 and and ?exit enemy-icon.image >bmp blit ;
: *test  spawn /test act> ~weapons ;



: roomwh  #cols #rows 16 16 2* ;
: roomxy  room# @ roomloc 32 - 16 16 2* ;
: roombox  ( - x y x y )  roomxy roomwh area ;

\ note: Tiled stores positions with Y representing the BOTTOM of the object.
\ we compensate by subtracting 16 from it.
:make enemyimage ( node gid - )
    2drop  at@ cr roombox inside? if roomxy 2negate 64 + 16 - +at *test then
;


( shoot shit at link )
: /shit  draw> 8 8 +at rndcolor 4 circf ;
: (limit)  act> in-playfield? not ?end ;
: (snipe)  p1 perform> 30 pauses toward 1.5 dup 2* vx 2! ;
: snipe  { me from spawn /shit (limit) (snipe) } ;

( stone statue )
: *statue  spawn /orb ['] snipe 270 every ;

( test enemy )
s" enemy-icon.png" >data image: enemy-icon.image
: /test  draw> damaged @ frmctr 1 and and ?exit enemy-icon.image >bmp blit ;
: *test  spawn /test act> ~weapons ;


: roomwh  #cols #rows 16 16 2* ;
: roomxy  room# @ srcrc 32 - 16 16 2* ;
: roombox  ( - x y x y )  roomxy roomwh aabb ;

\ note: Tiled stores positions with Y representing the BOTTOM of the object.
\ we compensate by subtracting 16 from it.
:make enemyimage ( node gid - )
    2drop  at@ roombox inside? if roomxy 2negate 64 + 16 - +at *test then
;

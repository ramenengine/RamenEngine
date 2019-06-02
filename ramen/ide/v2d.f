: vector:  ( x y - <name> )  create swap , , ;
: 2.  swap . . ;
: 2?  swap ? ? ;
: x@  @ ;
: y@  cell+ @ ;
: x!  ! ;
: y!  cell+ ! ;
: x+!  +! ;
: y+!  cell+ +! ;
: vclamp  ( lowx lowy highx highy vec - )  >r  2@ 2min 2max r> 2! ;
: 0v  0 0 rot 2! ;
: 1v  1 1 rot 2! ;
: 2rnd  ( x y - x y )  rnd swap rnd swap ;
: uvec  ( deg - x y )   >r  r@ cos  r> sin ;  \ get unit vector from angle
: vec  ( deg len - x y )  >r  uvec  r> dup 2* ;
: angle  ( x y - deg ) 1pf 1pf fatan2 r>d f>p  360 + 360 mod ;
: hypot  ( x y - n )  2pf fdup f* fswap fdup f* f+ fsqrt f>p ;
: 2rotate  ( x y deg - x y )
    swap  >rad dup cos  swap sin  locals| sin(ang) cos(ang) y x |
    x cos(ang) * y sin(ang) * -
    x sin(ang) * y cos(ang) * + ;
: vscale  ( x y vec - )
   >r  2@ 2*  r> 2! ;
: vlerp  ( vec1 vec2 n - x y )
    locals| n v2 v1 |
    v1 x@ v2 x@ n lerp  v1 y@ v2 y@ n lerp ;

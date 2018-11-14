\ Simple tilemap collision
depend ramen/lib/array2d.f

\ what sides the object collided
0 value lwall?
0 value rwall?
0 value floor?
0 value ceiling?

var mbw  var mbh  \ map box width,height

defer map-collide   ' drop is map-collide  ( tilecell - )

#1
    bit BIT_CEL
    bit BIT_FLR
    bit BIT_WLT
    bit BIT_WLR
value tile-bits

define tilecding
    : cel? BIT_CEL and ; \ ' ceiling '
    : flr? BIT_FLR and ; \ ' floor '
    : wlt? BIT_WLT and ; \ ' wall left '
    : wrt? BIT_WLR and ; \ ' wall right '
    : vector   create 0 , here 0 , constant ;
    vector nx ny
    variable t
    16 value gap
    : px x @ ;
    : py y @ ;

    : xy>cr  ( x y tilesize - ) dup  2/  2pfloor ;
    : pt  gap xy>cr  map@ dup t !  tileprops@ ;          \ point

    \ increment coordinates
    : ve+  swap gap +  mbw @ #1 - px +  min  swap ;
    : he+  gap +  mbh @ #1 - ny @ +  min ;

    : +vy ny +! ny @ py - vy ! ;
    : +vx nx +! nx @ px - vx ! ;

    \ push up/down
    : pu ( xy ) nip gap mod negate +vy  true to floor?  t @ map-collide  ;
    : pd ( xy ) nip gap mod negate gap + +vy  true to ceiling?  t @ map-collide ;

    \ check up/down
    : cu mbw @ gap / 2 + for 2dup pt cel? if pd unloop exit then ve+ loop 2drop ;
    : cd mbw @ gap / 2 + for 2dup pt flr? if pu unloop exit then ve+ loop 2drop ;


    \ push left/right
    : pl ( xy ) drop gap mod negate ( -1.0 + ) +vx  true to rwall?  t @ map-collide ;
    : pr ( xy ) drop gap mod negate gap + +vx  true to lwall?  t @ map-collide ;

    \ check left/right
    : cl mbh @ gap /  2 + for 2dup pt wrt? if pr unloop exit then he+ loop 2drop ;
    : crt mbh @ gap / 2 + for 2dup pt wlt? if pl unloop exit then he+ loop 2drop ;

    \ check if object's path crosses tile boundaries in the 4 directions...
    \ : dcros? py mbh @ + #1 - gap /  ny @ mbh @ + #1 - gap / < ;
    \ : ucros? py gap /  ny @ gap /  > ;
    \ : rcros? px mbw @ + #1 - gap /  nx @ mbw @ + #1 - gap / < ;
    \ : lcros? px gap /  nx @ gap /  > ;

    : ud vy @ -exit vy @ 0 < if ( ucros? -exit ) px ny @ cu exit then ( dcros? -exit ) px ny @ mbh @ + cd ;
    : lr vx @ -exit vx @ 0 < if ( lcros? -exit ) nx 2@ cl exit then ( rcros? -exit ) nx @ mbw @ + ny @ crt ;

    : init   to gap   px py  vx 2@  2+  nx 2!  0 to lwall? 0 to rwall? 0 to floor? 0 to ceiling? ;


only forth definitions fixed
also tilecding

: collide-map ( tilesize - ) init ud lr ;

\ 0 value (code)
\ : tiles>   ( w h tilesize - <code> )  ( gid - )
\     to gap  locals| h w |
\     r> to (code)
\     x 2@ at
\     h gap / pfloor 1 max for
\         at@ 2>r
\         w gap / pfloor 1 max for
\             at@ map@ >gid (code) call  gap 0 +at
\         loop
\         2r> gap + at
\     loop  drop ;


only forth definitions fixed
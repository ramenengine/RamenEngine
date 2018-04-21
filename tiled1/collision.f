\ Simple tilemap collision
\ Treats all non-zero tiles as solid.  No slope support.  To have tiles that don't have collision,
\ put them on another layer and don't perform collision on that.
\ You can move an object against the tilemap and also perform a check on every tile underneath
\ the object.

create tileprops  #16384 /allot  \ you could screw around with this to do one-way platforms

tileprops #1 +  #16383  $FF  fill

\ what sides the object collided
0 value lwall?
0 value rwall?
0 value floor?
0 value ceiling?

var w  var h

define tilecding
    defer map-collide   ' drop is map-collide  ( info -- )

    : cel? #1 and ; \ ' ceiling '
    : flr? #2 and ; \ ' floor '
    : wlt? #4 and ; \ ' wall left '
    : wrt? #8 and ; \ ' wall right '

    : p@  ( gid -- val )  1i tileprops + c@ ;

    : vector   create 0 , here 0 , constant ;
    vector w h
    vector nx ny
    variable t

    16 value gap

    : px x @ ;
    : py y @ ;

    \ point
    : pt  gap dup 2/  2pfloor  @tile >gid  dup t ! p@ ;

    \ increment coordinates
    : ve+  swap gap +  w @ #1 - px +  min  swap ;
    : he+  gap +  h @ #1 - ny @ +  min ;

    : +vy ny +! ny @ ( $ffff0000 and dup ny ! ) py - vy ! ;
    : +vx nx +! nx @ ( $ffff0000 and dup nx ! ) px - vx ! ;

    \ push up/down
    : pu ( xy ) nip gap mod negate +vy  true to floor?  t @ map-collide  ;
    : pd ( xy ) nip gap mod negate gap + +vy  true to ceiling?  t @ map-collide  ;

    \ check up/down
    : cu w @ gap / 2 + for 2dup pt cel? if pd unloop exit then ve+ loop 2drop ;
    : cd w @ gap / 2 + for 2dup pt flr? if pu unloop exit then ve+ loop 2drop ;


    \ push left/right
    : pl ( xy ) drop gap mod negate ( -1.0 + ) +vx  true to rwall?  t @ map-collide ;
    : pr ( xy ) drop gap mod negate gap + +vx  true to lwall?  t @ map-collide ;

    \ check left/right
    : cl h @ gap /  2 + for 2dup pt wrt? if pr unloop exit then he+ loop 2drop ;
    : crt h @ gap / 2 + for 2dup pt wlt? if pl unloop exit then he+ loop 2drop ;

    \ check if object's path crosses tile boundaries in the 4 directions...
    : dcros? py h @ + #1 - gap /  ny @ h @ + #1 - gap / < ;
    : ucros? py gap /  ny @ gap /  > ;
    : rcros? px w @ + #1 - gap /  nx @ w @ + #1 - gap / < ;
    : lcros? px gap /  nx @ gap /  > ;

    : ud vy @ -exit vy @ 0 < if ( ucros? -exit ) px ny @ cu exit then ( dcros? -exit ) px ny @ h @ + cd ;
    : lr vx @ -exit vx @ 0 < if ( lcros? -exit ) nx 2@ cl exit then ( rcros? -exit ) nx @ w @ + ny @ crt ;

    : init   to gap  x 2@  vx 2@  2+  nx 2!  0 to lwall? 0 to rwall? 0 to floor? 0 to ceiling? ;
    0 value (code)


only forth definitions also tilecding

: collide-map ( tilesize xt -- )  is map-collide  init ud lr ;

\ : tiles>   ( w h tilesize -- <code> )  ( gid -- )
\     to gap  w 2!
\     r> to (code)
\     x 2@ at
\     h @ gap / pfloor 1 max for
\         at@ 2>r
\         w @ gap / pfloor 1 max for
\             at@ map@ >gid (code) call  gap 0 +at
\         loop
\         2r> gap + at
\     loop  drop ;


only forth definitions
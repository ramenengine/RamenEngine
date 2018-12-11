empty
\ 16 11 array2d: roombuf
create roombuf
    16 , 11 , tilebuf pitch@ , 0 0 tilebuf loc ,

: /chr  draw> sprite+ ;

: >data  s" sample/zelda/data/" 2swap strjoin ;

16 16 s" link-tiles-sheet.png" >data tileset: link.ts
create rgns
0 , 0 , 16 , 16 , 8 , 8 ,
16 , 0 , 16 , 16 , 8 , 8 ,
32 , 0 , 16 , 16 , 8 , 8 ,
48 , 0 , 16 , 16 , 8 , 8 ,

stage object: link
link.ts img !
/chr
10 10 sx 2!

rgns link.ts 1 6 / anim: testanim 0 , 1 , 2 , 3 , ;anim
testanim
500 500 x 2!

s" overworld-rooms.tmx" >data open-map
s" testrooms1" find-tmxlayer tilebuf 0 64 load-tmxlayer
s" overworld-tiles.tsx" find-tileset# load-tileset
stage object: map0
/tilemap
256 172 w 2!
w 2@ 0 64 320 172 center x 2!

stage object: cam
:now act> x 2@ map0 's scrollx 2! ;

stage object: hud
map0 's x 2@ 64 - x 2!
:now draw> black 256 64 rectf ;


16 64 tilebuf adr-pitch 0 0 roombuf adr-pitch 16 cells 11 2move


: moveroom  16 cells 11 2move ;

: locroom  16 /mod 16 11 2* 64 + ;
: room  ( n - )
    locroom tilebuf adr-pitch
    0 0 roombuf adr-pitch
    moveroom ;


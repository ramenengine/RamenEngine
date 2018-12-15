

create roombuf %array2d struct,
    16  16  tilebuf pitch@  0 0 tilebuf loc  roombuf /array2d

( load the Tiled data )
s" overworld-rooms.tmx" >data open-map
    s" testrooms1" find-tmxlayer tilebuf  0 16 load-tmxlayer  \ load below the room buffer
    s" overworld-tiles.tsx" find-tileset# load-tileset

( loading a room )
: roomloc  #cols /mod #cols #rows 2* 16 + ;
: room  ( n - )
    roomloc tilebuf adr-pitch
    0 4 roombuf adr-pitch
    #cols cells #rows 2move  ;
0 room


( world )
: world create array2d-head, does> to ^map ;


( overworld map data )
16 8 world overworld  overworld
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $11 , $10 , $01 , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $00 , $31 , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
: warp  ( col row )  2dup coords 2!  ^map loc @ 1p room ;

( go north go south etc )
: gn  coords 2@ 0 -1 2+ warp ;
: gs  coords 2@ 0 1 2+ warp ;
: ge  coords 2@ 1 0 2+ warp ;
: gw  coords 2@ -1 0 2+ warp ;


:listen
    s" player-left-room" occured if
        x @ 0 <= if gw 256 16 - x ! ;then
        x @ 256 16 - >= if ge 0 x ! ;then
        y @ 64 16 + <= if gn 256 16 - y ! ;then
        y @ 256 16 - >= if gs 64 16 + y ! ;then
    then
;

\ old scrolling code::::

\ : fakeload   -vel  0 anmspd @!  15 pauses  anmspd ! ;
\ : shiftwait  begin pause scrshift @ 0= until
\     x @ 1 + dup 8 mod - x !  y @ 1 + dup 8 mod - y !  idle ;
\ : scroll  fakeload  godir  shiftwait ;

\     dirkeys? -exit
\     x @ camx @ -  0 <=  left? and             if  0 scroll  then
\     x @ camx @ -  320 mbw @ -  >=  right? and if  1 scroll  then
\     y @ camy @ 8 + -  0 <=  up? and           if  2 scroll  then
\     y @ camy @ -  208 mbh @ -  >=  down? and  if  3 scroll  then ;
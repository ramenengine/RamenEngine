create roombuf %array2d struct,
    16  11  tilebuf pitch@  0 0 tilebuf loc  roombuf /array2d
s" overworld-rooms.tmx" >data open-map
s" testrooms1" find-tmxlayer tilebuf 0 64 load-tmxlayer
s" overworld-tiles.tsx" find-tileset# load-tileset
: roomloc  #cols /mod #cols #rows 2* 64 + ;
: room  ( n - )
    roomloc tilebuf adr-pitch
    0 0 roombuf adr-pitch
    #cols cells #rows 2move  ;
0 room
: world create array2d-head, does> to ^map ;
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

\ go north go south etc
: gn  coords 2@ 0 -1 2+ warp ;
: gs  coords 2@ 0 1 2+ warp ;
: ge   coords 2@ 1 0 2+ warp ;
: gw   coords 2@ -1 0 2+ warp ;

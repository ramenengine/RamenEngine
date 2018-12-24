
create roombuf %array2d struct,
    16  16  tilebuf pitch@  0 0 tilebuf loc  roombuf /array2d

( load the Tiled data )
s" overworld-rooms.tmx" >data open-map
    s" testrooms1" find-tmxlayer tilebuf  0 32 load-tmxlayer  \ load well below the room buffer
    s" overworld-tiles.tsx" find-tileset# load-tileset


( loading a room )
defer enemyimage  ' 2drop is enemyimage
create enemy-handlers  0 , ' enemyimage , 0 ,
: *enemies
    s" overworld-rooms.tmx" >data open-map
    s" Enemy Locations" find-objgroup enemy-handlers load-objects
;
: roomloc  #cols /mod #cols #rows 2* 32 + ;
: room  ( i - )  \ expressed as $rc  r=row c=column
    cleanup
    1p dup room# ! roomloc tilebuf adr-pitch
    0 4 roombuf adr-pitch
    #cols cells #rows 2move
    0 ['] *enemies later
;
0 room

: cave  ( - )
    $37 room 128 8 - 236 8 - 2 s" player-entered-cave" occur ;


( world )
struct %world
    %world %array2d sizeof sfield world.rooms
    %world svar world.num
create worlds 20 array,

: world^  world# @ worlds []@ ;
: worldloc  world^ loc 
: world ( n - )  20 mod world# ! ;
: does-world  does> world.num @ world ;
: /world  ( n world - )  >r 20 mod dup r@ world.num ! r> swap worlds [] ! ;
: world:  ( n - <name> ) create %world *struct /world does-world ;
: warp  ( col row )  2dup coords 2!  world^ loc c@ room ;


( go north go south etc )
: gn  coords 2@ 0 -1 2+ warp ;
: gs  coords 2@ 0 1 2+ warp ;
: ge  coords 2@ 1 0 2+ warp ;
: gw  coords 2@ -1 0 2+ warp ;

: return  coords 2@ warp ;

: in-playfield? ( - flag ) x 2@  -1 63 8 + 257 237 16 8 2- inside? ;

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
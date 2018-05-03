empty
$000100 include ramen/brick

" data/2200man.png" image: 2200man.image  21 36 2200man.image subdivide
" data/alfador.png" image: alfador.image  18 20 alfador.image subdivide
" data/fairgirl.png" image: fairgirl.image  21 28 fairgirl.image subdivide

\ ENUM doesn't work as expected...
0 constant DIR_DOWN
1 constant DIR_UP
2 constant DIR_RIGHT
3 constant DIR_LEFT

redef on
    var dir    \ direction, see above enums
    var img    \ current image used for animation; tied to animation data (flipbooks)
    var data   \ static NPC data, like animation pointers

    \ internal:
        var anm  \ animation pointer
        var ctr  \ animation counter
        var spd  \ higher is slower; set by ANIMATE; note there is a hardcoded value passed by NPC-SPRITE
redef off

: ?anmloop  anm @ @ 0 >= ?exit  anm @ cell+ @ anm ! ;
: animate  ( speed -- adr | 0 )  \ adr points to a cell in the animation data
    spd !
    anm @ if  1 ctr +!  ctr @ spd @ >= if  0 ctr !  cell anm +!  ?anmloop  then  anm @
    else  0  then ;

: flipbook:  ( -- <name> [data] loopdest )  \ first cell should be an image
    create  here cell+ ( loopdest )  [char] ; parse evaluate  -1 ,  ( loopdest ) ,
    does>   @+  img !  anm !  ;
: [loop]  drop here ;

flipbook: girl-down  fairgirl.image , 0 , 1 , 0 , 2 , ;
flipbook: girl-left  fairgirl.image , 3 , 4 , 3 , 4 , ;
flipbook: girl-up    fairgirl.image , 5 , 6 , 5 , 7 , ;
flipbook: man-down   2200man.image  , 1 , 2 , 3 , 4 , ;
flipbook: man-left   2200man.image  , 5 , 6 , 5 , 7 , ;
flipbook: man-up     2200man.image  , 9 , 10 , 11 , 12 , ;
flipbook: cat-down   alfador.image  , 1 , 2 , 3 , 4 , ;
flipbook: cat-left   alfador.image  , 6 , 7 , 8 , 7 , ;
flipbook: cat-up     alfador.image  , 10 , 11 , 12 , 13 , ;


: data@   ( n -- value )  cells data @ + @ ;
: flipdata@  4 + data@ ;
: sprite  ( dir -- )   pfloor data@ execute ;
: turn    ( dir -- )   pfloor dup dir !  sprite ;
: flip@  dir @ flipdata@ ;
: chrw  img @ image.subw @ ;
: sprh  img @ image.subh @ ;
: chrh  16 ;
: >feet  ( y -- y )  sprh - 4 + ;
: npc-sprite  16 animate @ img @ afsubimg  at@ >feet 2af  flip@  al_draw_bitmap_region ;
: npc   ( -- <name> )  ( me=obj -- )    create
    does>  data !  DIR_DOWN turn  draw>  npc-sprite ;

npc girl  ' girl-down , ' girl-up , ' girl-left , ' girl-left ,
                    0 ,         0 ,      FLIP_H ,           0 ,

npc man   ' man-down , ' man-up , ' man-left , ' man-left ,
                   0 ,        0 ,     FLIP_H ,          0 ,

npc cat   ' cat-down , ' cat-up , ' cat-left , ' cat-left ,
                   0 ,        0 ,     FLIP_H ,          0 ,


\ Random walking logic; doing it without tasks to avoid unnecessary coupling
\ quick n' dirty !!!

var wc  \ walk counter, at 0 NPC will stop and after a bit turn in a random direction and walk.
        \ if the NPC hits the boundaries it will just be impeded by a force field.

defer wander
defer walk
: walkv  dir @ case
        DIR_DOWN  of 0 0.5   exit endof
        DIR_UP    of 0 -0.5  exit endof
        DIR_RIGHT of 0.5 0   exit endof
        DIR_LEFT  of -0.5 0  exit endof
    endcase
    0 0 ;
: -wc  wc --  wc @ -1 > ;
: ?turn  4 rnd turn ;
: aboutface  dir @ 1 xor turn ;
: limit
    x @ 0 <  x @ displayw 3 / chrw - > or
    y @ chrh < or  y @ displayh 3 / > or if  aboutface  walk  then
    x 2@  0 chrh  displaywh 3 3 2/  chrw 0 2- 2clamp  x 2!
    ;
: :is  :noname  postpone [  [compile] is  ] ;
:is walk   walkv vx 2!
    0.5 2 between fps * wc !
    act>  limit  -wc ?exit  wander ;
:is wander  0 0 vx 2!
    1 3 between fps * wc !
    act>  limit  -wc ?exit  ?turn walk ;

objlist stage
stage 500 pool: sprites

\ Create a bunch of randomized NPC's
create roster  ' girl , ' man , ' cat ,
: someone   3 rnd cells roster + @  execute ;
: sprinkle  0 do  displaywh 3 3 2/ 2rnd at  sprites one  someone  ?turn  wander  loop  ;

\ 3X scaling
0 0 3 3 0 transform: m0
: magnified  m0 al_use_transform  ;

250 sprinkle

: think  stage each> act ;
: locomote  stage each> vx x v+  y @ zdepth ! ;
: playfield  stage drawzsorted ;
: (step)  step>  think  locomote ;
: (go)  go>  noop ;
: (show)  show>  grey backdrop  magnified playfield ;
: go  (go)  (step)  (show) ;

go ok
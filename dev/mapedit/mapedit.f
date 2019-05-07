include ramen/ramen.f
#2 #0 #0 [ws] [checkver]
#2 #0 #0 [ramen] [checkver]
empty
project: dev/mapedit
depend ramen/basic.f                    \ load the basic packet
depend ramen/lib/std/tilemap2.f         \ load tilemap support
nativewh resolution

ld apptools
0 tilebank

create tilemap$  256 /allot
create tileset$  256 /allot
create palette$  256 /allot
variable curTile  1 curtile !
create palette  %image sizeof /allot
create curColor 1e sf, 1e sf, 1e sf, 1e sf,

: mapedit:show  show> ramenbg unmount stage draws ;

: @color  curColor fore 4 cells move ;

( tile clipboard )
0 value cbbmp  \ clipboard bitmap
: selection  ( - bmp x y w h )  curTile @ tile>rgn ;
: cbbmp! cbbmp -bmp  to cbbmp ;
: copy   tb subwh *bmp dup cbbmp!  onto> selection movebmp ;
: paste  tb >bmp onto>  selection 2drop at ( bmp ) drop  cbbmp 0 0 third bmpwh movebmp ;


( layout )
: beside  { y @   x @ w @ sx @ * + } 16 + x !   y ! ;
: below   { x @   y @ h @ sy @ * + } 16 + y !   x ! ;
: outline  w 2@ sx 2@ 2*  2dup  white rect  -1 -1 +at  2 2 2+ black rect ;

stage actor: tileseta  2 2 sx 2!  16 16 x 2!
    :noname  draw>  tb img !  img @ imagewh w 2!
                 0 0 tb imagewh 0 bsprite
                 outline ; execute

stage actor: mapa   /tilemap  256 256 w 2!  2 2 sx 2!  16 16 x 2!
    :now  draw>  tileseta beside  outline  me transform>   w 2@ black 0.5 alpha rectf  tilemap ;

stage actor: tilea  16 16 sx 2!  16 16 w 2!  
    :now  draw>  mapa below  outline  me transform>  curTile @ tile  ;

stage actor: colora  256 16 w 2!
    :now  draw>  outline  tilea below  @color  1 1 +at  w 2@ rectf ;

stage actor: pala  24 24 sx 2!  palette img ! 
    :now  draw> palette imagewh w 2!  colora below  sprite ;


stage actor: hilitea  
    :noname draw>  curTile @ -exit
                tilea { w 2@ }  tileseta { sx 2@ }  2*  w 2!
                tileseta { curTile @ 1 - tb subxy sx 2@ 2*   x 2@ 2+ }  x 2!
                outline ; execute

: subcols  image.subcols @ ;

: box  x 2@ w 2@ sx 2@ 2* aabb 1 1 2- ;
: (tile)  mapa { curtile @ maus x 2@ 2- sx 2@ 2/ scrollx 2@ 2+ tb subwh 2/ tilebuf loc } ;
: that   (tile) @ curtile ! ;
: lay  (tile) ! ;
: mpos  maus x 2@ 2- sx 2@ 2/ ;
: pick   mpos tb subwh 2/ 2pfloor tb subcols * + 1 + curtile ! ;
: crayon  curColor  img @ >bmp  mpos 2i  al_get_pixel ;
: paint  selection 2drop rot onto> mpos 2+ 2i curColor 4@ al_put_pixel ;
: eyedrop  curColor selection 2drop mpos 2+ 2i al_get_pixel ;
: hovering?  maus box within? ;
: interact?  @ hovering? and ;
: pan  mdelta globalscale dup 2/ sx 2@ 2/ 2negate scrollx 2+! ;

ld stamp

stage actor: ctl
:noname act>
    mapa as 
        <space> kstate lb @ and if  pan  ;then
        lb interact? if  lay  ;then
        rb interact? if  that   ;then
    tilea as 
        lb interact? if  paint  then
        rb interact? if  eyedrop  then
    tileseta as 
        lb interact? if  pick  then
    pala as 
        lb interact? if  crayon  then
        rb interact? if  crayon  then
; execute

: tilebankbmp ( n - bmp )
    tb >r  tilebank  tb >bmp   r> to tb ;

: save-tileset
    tileset$ @ 0= if  tileset$ image-formats ossave -exit then
    0 tilebankbmp tileset$ count savebmp
;

: save-tilemap
    tilemap$ @ 0= if  tilemap$ s" *.buf" ossave -exit then
    tilebuf count2d tilemap$ count file!
;

: tw  tb subwh drop ;
: th  tb subwh nip ;

: sw  shift? if mapa 's w @ else tw then ;
: sh  shift? if mapa 's h @ else th then ;

: snap  mapa {  scrollx 2@ 2dup sw sh 2mod 2- scrollx 2!  } ;

: ?eraser
    mapa { hovering? } if 0 curtile ! ;then
    tilea { hovering? } if 0 0 0 0 4af curColor 4! ;then
;


: (load-tilemap)  tilemap$ count 0 0 tilebuf loc 512 512 * cells @file ;
: (load-tileset)  0 tilebank  tileset$ count 16 16 loadtileset ;
: (load-palette)  palette$ count palette load-image ;

s" dev\mapedit\smoothfbx.png" palette load-image 

also wsing
    s" Test" label named test
    : (p.)  1pf #2 (f.) ;
    stage one
    :now act> mapa 's scrollx 2@ swap (p.) s[ (p.) +s ]s test { data! } ;    
previous

nr
s" save" button
nr
s" Tileset" label
option: clear-tile
    selection 2drop rot onto> at
    write-src blend>  black 0 alpha 16 16 rectf
;
option: fill-tile
    selection 2drop rot onto> at
    @color  write-src blend> 16 16 rectf
;
option: revert-tileset  (load-tileset) ;
nr
s" save-tileset" button
option: new-tileset  16 16 256 1024 dimbank  tileset$ off ; 
option: load-tileset  tileset$ image-formats osopen if (load-tileset) then ;
nr
s" Tilemap" label
option: revert-tilemap  (load-tilemap) ;
nr
s" save-tilemap" button
option: new-tilemap  tilebuf clear2d  tilemap$ off ;
option: load-tilemap  tilemap$ s" *.buf" osopen if (load-tilemap) then ;
nr
s" Palette" label
option: load-palette  palette$ image-formats osopen if (load-palette) then ;

nr s" <space> + LB = Pan" label
nr s" cursor keys = Pan (shift = by screens)" label
nr s" RB = Eyedropper" label
nr s" <ctrl> + <s> = Save" label
nr s" <ctrl> + <c> / <v> = Copy/Paste" label
nr s" <e> = Select tile 0 / transparent" label
nr s" Resize viewport: <w> <h> mapa 's w 2! " label
nr

: save  save-tileset save-tilemap  cr ." Saved." ;
: empty  tileset$ @ if save-tileset then
         tilemap$ @ if save-tilemap then
         empty ;

: load
    (load-palette) (load-tileset) (load-tilemap) ;

: ?copy  
    mapa { hovering? } if stampify ;then
    copy ;
    
: ?paste
    mapa { hovering? } if stamp ;then
    paste ;

: mapedit-events
    etype ALLEGRO_EVENT_KEY_CHAR = if
        keycode <s> = ctrl? and if  s" save" evaluate ;then
        keycode <e> = if  ?eraser  ;then
        keycode <c> = ctrl? and if  ?copy  ;then
        keycode <v> = ctrl? and if  ?paste  ;then
        keycode <del> = if  clear-tile  ;then
        keycode <up> = if     snap  sh negate mapa 's scrolly +!  ;then
        keycode <down> = if   snap  sh mapa 's scrolly +!  ;then
        keycode <left> = if   snap  sw negate mapa 's scrollx +! ;then
        keycode <right> = if  snap  sw mapa 's scrollx +! ;then
    then
;

: mapedit:pump  pump> app-events mapedit-events ;

: mapedit
    page
    repl off
    mapedit:pump
    mapedit:show
;
mapedit


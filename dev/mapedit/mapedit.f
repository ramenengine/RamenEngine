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

create curTilemap$  256 /allot   s" dev/mapedit/zelda.buf" curTilemap$ place
create curTileset$  256 /allot  s" dev/mapedit/overworld-tiles.png" curTileset$ place
create curPalette$  256 /allot  s" dev/mapedit/NES_palette.png" curPalette$ place
variable curTile  1 curtile !
create palette  %image sizeof /allot
create curColor 1e sf, 1e sf, 1e sf, 1e sf,
: !color  curColor fore 4 cells move ;

: mapedit:show  show> ramenbg unmount stage draws ;
mapedit:show

: beside  >{ y @   x @ w @ sx @ * + } 16 + x !   y ! ;
: below   >{ x @   y @ h @ sy @ * + } 16 + y !   x ! ;
: outline  w 2@ sx 2@ 2*  2dup  white rect  -1 -1 +at  2 2 2+ black rect ;

stage actor: map0   /tilemap  256 256 w 2!  2 2 sx 2!  16 16 x 2!
    :now draw>  me transform>  0 0 at  tilemap ;

stage actor: tile0  16 16 sx 2!  16 16 w 2!
    :now  draw>  map0 below  outline  me transform>  0 0 at  curTile @ tile  ;

stage actor: color0  256 16 w 2!
    :now  draw>  tile0 below  !color  w 2@ rectf ;

stage actor: palette0  1.5 1.5 sx 2!  palette img ! 
    :now  draw> palette imagewh w 2!  color0 below  sprite ;

stage actor: tileset0  2 2 sx 2!  
    :now  draw>  map0 beside  tb img !  img @ imagewh w 2!  0 0 tb imagewh 0 bsprite ;

stage actor: hilite0  
    :noname draw>  curTile @ -exit
                tile0 >{ w 2@ sx 2* } w 2!
                tileset0 >{ curTile @ 1 - tb subxy sx 2@ 2*   x 2@ 2+  }  x 2!
                outline ; execute



: subcols  image.subcols @ ;

: box  x 2@ w 2@ sx 2@ 2* aabb 1 1 2- ;
: (tile)  map0 >{ curtile @ maus x 2@ 2- sx 2@ 2/ scrollx 2@ 2+ tb subwh 2/ tilebuf loc } ;
: that   (tile) @ curtile ! ;
: lay  (tile) ! ;
: mpos  maus x 2@ 2- sx 2@ 2/ ;
: pick   mpos tb subwh 2/ 2pfloor tb subcols * + 1 + curtile ! ;
: crayon  curColor  img @ >bmp  mpos 2i  al_get_pixel ;
: paint  curTile @ tile>rgn 2drop rot onto> mpos 2+ 2i curColor 4@ al_put_pixel ;
: eyedrop  curColor curTile @ tile>rgn 2drop mpos 2+ 2i al_get_pixel ;
: interact?  @ maus box within? and ;
: pan  mdelta globalscale dup 2/ sx 2@ 2/ 2negate scrollx 2+! ;

stage actor: ctl
:noname act>
    map0 as 
        <space> kstate lb @ and if  pan  ;then
        lb interact? if  lay  ;then
        rb interact? if  that   ;then
    tile0 as 
        lb interact? if  paint  then
        rb interact? if  eyedrop  then
    tileset0 as 
        lb interact? if  pick  then
    palette0 as 
        lb interact? if  crayon  then
        rb interact? if  crayon  then
; execute

: tilebankbmp ( n - bmp )
    tb >r  tilebank  tb >bmp   r> to tb ;

: save-tileset
    curTileset$ @ 0= if  curTileset$ image-formats ossave -exit then
    0 tilebankbmp curTileset$ count savebmp
;

: save-tilemap
    curTilemap$ @ 0= if  curTilemap$ s" *.buf" ossave -exit then
    tilebuf count2d curTilemap$ count file!
;

: tw  tb subwh drop ;
: th  tb subwh nip ;

: sw  shift? if map0 's w @ else tw then ;
: sh  shift? if map0 's h @ else th then ;

: mapedit-events
    etype ALLEGRO_EVENT_KEY_CHAR = if
        keycode <e> = if  0 curtile !  ;then
        keycode <up> = if     sh negate map0 's scrolly +! ;then
        keycode <down> = if   sh map0 's scrolly +! ;then
        keycode <left> = if   sw negate map0 's scrollx +! ;then
        keycode <right> = if  sw map0 's scrollx +! ;then
    then
;

: mapedit:pump  pump> app-events mapedit-events ;
mapedit:pump

: (load-tilemap)  curTilemap$ count 0 0 tilebuf loc 512 512 * cells @file ;
: (load-tileset)  0 tilebank  curTileset$ count 16 16 loadtileset ;
: (load-palette)  curPalette$ count palette load-image ;

nr
s" save" button
nr
s" Tileset" label
option: clear-tile
    curTile @ tile>rgn 2drop rot onto> at
    !color  16 16 rectf
;
option: revert-tileset  (load-tileset) ;
s" save-tileset" button
option: new-tileset  16 16 256 1024 dimbank  curTileset$ off ; 
option: load-tileset  curTileset$ image-formats osopen if (load-tileset) then ;
nr
s" Tilemap" label
s" save-tilemap" button
option: revert-tilemap  (load-tilemap) ;
option: new-tilemap  tilebuf clear2d  curTilemap$ off ;
option: load-tilemap  curTilemap$ s" *.buf" osopen if (load-tilemap) then ;
nr
s" Palette" label
option: load-palette  curPalette$ image-formats osopen if (load-palette) then ;

nr
s" Resize viewport: <w> <h> tilemap0 's w 2! " label
nr
(load-tileset)
(load-tilemap)
(load-palette)

: save  save-tileset save-tilemap ;
: empty  save empty ;

page
repl off
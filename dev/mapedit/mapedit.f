include ramen/ramen.f
#2 #0 #0 [ws] [checkver]
#2 #0 #0 [ramen] [checkver]
empty
project: dev/mapedit
depend ramen/basic.f                    \ load the basic packet
depend ramen/lib/std/tilemap2.f         \ load tilemap support
nativewh resolution

ld apptools

create curMapFile  256 /allot   s" dev/mapedit/zelda.buf" curMapFile place
create curTilesetFile  256 /allot  s" dev/mapedit/overworld-tiles.png" curTilesetFile place
variable curTile  4 curtile !

: mapedit:show  show> ramenbg unmount stage draws ;
mapedit:show

stage actor: map0   /tilemap  256 256 w 2!  2 2 sx 2!  0 0 x 2!
    :now draw>  me transform> tilemap ;
    
stage actor: tile0  524 0 x 2!  16 16 sx 2!
    :now draw>  me transform> 0 0 at curTile @ tile ;

stage actor: tileset0  524 268 x 2!  2 2 sx 2!  
    :now draw>  tb img !  img @ imagewh w 2!  0 0 tb imagewh 0 bsprite ;

: subcols  image.subcols @ ;

: box  x 2@ w 2@ sx 2@ 2* aabb ;
: (tile)  map0 >{ curtile @ maus x 2@ 2- sx 2@ 2/ scrollx 2@ 2+ tb subwh 2/ tilebuf loc } ;
: that   (tile) @ curtile ! ;
: paint  (tile) ! ;
: pick   maus x 2@ 2- sx 2@ 2/ tb subwh 2/ 2pfloor tb subcols * + 1 + curtile ! ;

map0 as :noname act>
    lb @ if
        maus box within? if
            paint
        then
    then
    rb @ if
        maus box within? if
            that
        then
    then
; execute

tileset0 as :noname act>
    lb @ if
        maus box within? if
            pick
        then
    then
; execute


: tilebankbmp ( n - bmp )
    tb >r  tilebank  tb >bmp   r> to tb ;

: save
    0 0 tilebuf loc 512 512 * cells curMapFile count file!
    0 tilebankbmp curTilesetFile count savebmp
;

: empty  save empty ;

: tw  tb subwh drop ;
: th  tb subwh nip ;
: -tw  tw negate ;
: -th  th negate ;

: mapedit-events
    etype ALLEGRO_EVENT_KEY_CHAR = if
        keycode <e> = if  0 curtile !  ;then
        keycode <up> = if     -th map0 's scrolly +! ;then
        keycode <down> = if   th map0 's scrolly +! ;then
        keycode <left> = if   -tw map0 's scrollx +! ;then
        keycode <right> = if  tw map0 's scrollx +! ;then
    then
;

: mapedit:pump  pump> app-events mapedit-events ;
mapedit:pump

: (load-tilemap)  curMapFile count 0 0 tilebuf loc 512 512 * cells @file ;

: (load-tileset)  0 tilebank  curTilesetFile count 16 16 loadtileset ;

nr
option: load-tilemap  curMapFile s" *.buf" osopen if (load-tilemap) then ;
option: load-tileset  curTilesetFile s" *.png" osopen if (load-tileset) then ;
\ option: load-palette ;
\ option: load-project ;
\ option: new-project ;
s" save" button

(load-tileset)
(load-tilemap)
\ load-palette

page
repl off
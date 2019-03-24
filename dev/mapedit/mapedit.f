include ramen/ramen.f
#2 #0 #0 [version] [ws]
#2 #0 #0 [ramen] [checkver]
empty
project: dev/mapedit
depend ramen/basic.f                    \ load the basic packet
depend ramen/lib/std/tilemap2.f         \ load tilemap support
1024 768 resolution
variable curTile  4 curtile !
variable lb
variable rb

stage one :now act> ui on ;  \ workspace always on

: mapedit:show  show> ramenbg unmount stage draws ;
mapedit:show

: ?b  
    evt ALLEGRO_MOUSE_EVENT.button @ #1 = if lb ;then
    evt ALLEGRO_MOUSE_EVENT.button @ #2 = if rb ;then
;

: mapedit:pump  pump>
    etype ALLEGRO_EVENT_MOUSE_BUTTON_DOWN = if ?b on then
    etype ALLEGRO_EVENT_MOUSE_BUTTON_UP = if ?b off then
;
mapedit:pump

stage actor: map0   /tilemap  256 256 w 2!  3 3 sx 2!  0 0 x 2!
    :now draw>  me transform> tilemap ;
    
stage actor: tile0  800 0 x 2!  16 16 sx 2!
    :now draw>  me transform> 0 0 at curTile @ tile ;


: maus   mouse 2@ globalscale dup 2/ ;

also wsing
    s" Test" label named mauser
    : (p.)  1pf #2 (f.) ;
    stage one
    :now act> maus swap (p.) s[ (p.) +s ]s mauser >{ data! } ;    
previous

: box  x 2@ w 2@ sx 2@ 2* aabb ;
: (tile)  map0 >{ curtile @ maus x 2@ 2- sx 2@ 2/ scrollx 2@ 2+ tb subwh 2/ tilebuf loc } ;
: pick   (tile) @ curtile ! ;
: paint  (tile) ! ;

map0 as :noname act>
    lb @ if
        maus box within? if
            paint
        then
    then
    rb @ if
        maus box within? if
            pick
        then
    then
; execute


( load test data )
s" dev/mapedit/zelda.buf" 0 0 tilebuf loc 512 512 * cells @file
0 tilebank 16 16 288 256 dimbank
0 0 at s" dev/mapedit/overworld-tiles.png" loadtiles




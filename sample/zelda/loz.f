empty
: >data  s" sample/zelda/data/" 2swap strjoin ;

( "engine" )
include sample/zelda/tools.f
include sample/zelda/globals.f
include sample/zelda/common.f

( game specific stuff )
include sample/zelda/lib.f
include sample/zelda/map.f
include sample/zelda/objtypes.f

256 236 resolution

( extend loop )
: think  ( - ) stage acts tasks multi world multi stage multi tasks acts ;
: physics ( - ) stage each> as ?physics vx 2@ x 2+! ;
: zelda-step ( - ) step> think physics interact stage sweep ;
zelda-step

: /bg   bg as /tilemap 256 256 w 2! ;
: /cam  cam as act> x 2@ bg 's scrollx 2! ;
: /hud  hud as bg 's x @ 0 x 2! draw> black 256 64 rectf ;

: urhere  at@ x 2@ coords 2@ 4 4 2* 2+ at 5 5 rectf at ;
: mapgrid
    8 for
        16 for
            5 5 rect
            4 0 +at
        loop
        4 -16 * 4 +at
    loop
;
: /minimap  minimap as 16 16 hud situate draw> red urhere grey mapgrid ;

( overworld map data )
16 8 defworld overworld  overworld
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $11 , $10 , $01 , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $00 , $31 , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 

:listen
    s" player-left-room" occurred if
        in-cave @ if
            overworld return
            in-cave off
            dialog off
            0 s" player-exited-cave" occur
        else 
            x @ 0 <= if gw 256 16 - x ! ;then
            x @ 256 16 - >= if ge 0 x ! ;then
            y @ 64 16 + <= if gn 256 16 - y ! ;then
            y @ 256 16 - >= if gs 64 16 + y ! ;then
        then
    ;then
    s" player-entered-cave" occurred if
        ( x y ) in-cave on
    ;then
;

: adventure
    cleanup
    /bg /cam /hud /minimap 
    link as hidden on 
    overworld 3 3 warp
    curtain-open
    link as 64 after>
        64 96 x 2!
        /link  
        \ test objects:
        64 128 at *orb
\        64 180 at *statue
;

include ramen/lib/upscale.f
:now show> ramenbg upscale> stage draws ;

adventure

ld sample/zelda/tests

\ cr .( [Zelda] )
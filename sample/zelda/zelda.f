empty
include sample/zelda/tools.f
include sample/zelda/vars.f
include sample/zelda/data.f
include sample/zelda/map.f
include sample/zelda/items.f
include sample/zelda/link.f
include sample/zelda/enemies.f

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

: after>  ( n - <code> )  r> code> swap after ;

:listen
    s" player-left-room" occurred if
        in-cave @ if
            overworld return
            in-cave off
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
    zelda-step
    /bg /cam /hud /minimap
    curtain-open
    link as hidden on
    64 after>
    /link  64 96 x 2!  
    link from *orb
    64 128 at *statue
;

adventure

\ show-cboxes


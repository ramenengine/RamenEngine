empty
include sample/zelda/vars.f
include sample/zelda/data.f
include sample/zelda/tools.f
include sample/zelda/map.f
include sample/zelda/items.f
include sample/zelda/link.f

( overworld scene! )
: /bg   bg as /tilemap 256 256 w 2! ;
: /cam  cam as act> x 2@ bg 's scrollx 2! ;
: /hud  hud as bg 's x @ 0 x 2! draw> black 256 64 rectf ;

: urhere  at@ x 2@ coords 2@ 4 4 2* 2+ at 5 5 rectf at ;
: mapgrid
    8 for
        16 for
            5 5 white rect
            4 0 +at
        loop
        4 -16 * 4 +at
    loop
;
: /minimap  minimap as 16 16 hud situated draw> red urhere mapgrid ;

:listen
    s" player-entered-cave" occurred if
        in-cave on
    ;then
    s" player-exited-cave" occurred if
        in-cave off 
    ;then
;

/bg /cam /hud /minimap 

link as 192 128 x 2!  hidden on 

curtain-open

' /link 64 after

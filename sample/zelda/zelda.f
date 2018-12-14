empty
include sample/zelda/vars.f
include sample/zelda/data.f
include sample/zelda/tools.f
include sample/zelda/map.f
include sample/zelda/link.f

: /bg   bg as /tilemap 256 172 w 2! w 2@ 0 64 320 172 center x 2! ;
: /cam  cam as act> x 2@ bg 's scrollx 2! ;
: /hud  hud as 0 -64 bg situated draw> black 256 64 rectf ;

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

/bg /cam /hud /minimap /link

link as 128 128 x 2!


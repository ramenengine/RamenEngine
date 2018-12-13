empty
include sample/zelda/vars.f
include sample/zelda/data.f
include sample/zelda/tools.f
include sample/zelda/map.f

: urhere  at@ x 2@ coords 2@ 4 4 2* 2+ at  blue 4 4 rectf  at ;

: /bg   bg as /tilemap 256 172 w 2! w 2@ 0 64 320 172 center x 2! ;
: /cam  cam as act> x 2@ bg 's scrollx 2! ;
: /hud  hud as 0 -64 bg situated draw> black 256 64 rectf ;
: /minimap  minimap as 16 16 hud situated draw>
    urhere
    8 for
        16 for
            4 4 white rect
            4 0 +at
        loop
        4 -16 * 4 +at
    loop
;
include sample/zelda/link.f
/bg /cam /hud /minimap /link

link as 128 128 x 2!


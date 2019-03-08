: /hud  hud as bg0 's x @ 0 x 2! draw> black 256 64 rectf ; <ui
: urhere  at@ x 2@ coords 2@ 4 4 2* 2+ at 5 5 rectf at ; <ui
: mapgrid
    8 for
        16 for
            5 5 rect
            4 0 +at
        loop
        4 -16 * 4 +at
    loop
;
: /minimap  minimap as hud 16 16 from situate draw> red urhere grey mapgrid ; <ui

include ramen/ramen.f
empty
project: dev/mapedit
depend ramen/basic.f                    \ load the basic packet
depend ramen/lib/std/tilemap2.f         \ load tilemap support
1024 768 resolution

variable curTile  4 curtile !

stage actor: test  :now  draw> 16 16 red rectf ;

stage actor: map0   /tilemap  256 256 w 2!  2 2 sx 2!  0 0 x 2!
    :now draw> mount me transform> tilemap ;
    
stage actor: tile0  520 0 x 2!  4 4 sx 2!
    :now draw> mount me transform> 0 0 at curTile @ tile ;

s" dev/mapedit/zelda.buf" 0 0 tilebuf loc 512 512 * cells @file
0 tilebank 16 16 288 256 dimbank
0 0 at s" dev/mapedit/overworld-tiles.png" loadtiles



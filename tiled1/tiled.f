$10000 [version] tiled-ver

\ Tiled module for RAMEN

\ Basically everything you need to make a 2D game.


$000100 include ramen/lib/array2d
include ramen/tiled1/tmx
include ramen/tiled1/tilegame
include ramen/tiled1/loadtmx
include ramen/tiled1/tilemap
include ramen/tiled1/tilcd


: convert-tile   dup 2 << over $80000000 and 1 >> or swap $40000000 and 1 << or ;
: convert-tilemap  ( col row #cols #rows array2d -- )
    some2d> cells bounds do i @ convert-tile i ! cell +loop ;

: get  ( layernode destcol destrow -- )
    3dup tilebuf addr-pitch extract  rot @wh tilebuf convert-tilemap ;

: open  ( map -- )  count opentmx  load-tiles ;

: map  ( -- <name> <filespec> )  ( -- map )  create <filespec> string, ;

var onhitmap  \ XT;  ( info -- )  must be assigned to something to enable tilemap collision detection
var mbx       \ map hitbox; exclusively for colliding with the TILEBUF; expressed in relative coords
var mby       \
var mbw       \
var mbh       \
augment


: onhitmap>  ( -- <code> ) r> code> onhitmap ! ;
: collide-objects-map  ( objlist tilesize -- )
    locals| tilesize |
    each>   x 2@  mbx 2@ x 2+!  onhitmap @ if  mbw 2@  tilesize  onhitmap @ collide-map  then
            x 2! ;

[section] preamble
$10000 [version] tiled-ver
\ Tiled module for RAMEN

[undefined] draw-ver [if] $000100 include ramen/lib/draw [then]
[undefined] array2d-ver [if] $000100 include ramen/lib/array2d [then]
include ramen/tiled1/tilegame

\ -------------------------------------------------------------------------------------------------
[section] buffers

1024 1024 array2d: tilebuf
1000 cellstack: bitmaps
1000 cellstack: initializers

\ -------------------------------------------------------------------------------------------------
[section] tilemap

\ Tilemap objects
\ A large singular 2D array is used for stability

var scrollx  var scrolly  \ used to define starting column and row!
var w  var h              \ width & height in pixels

: /tilemap
    displaywh w 2!
    draw>
        at@ w 2@ clip>
        scrollx 2@  20 20 scroll  tilebuf loc  tilebuf pitch@  draw-tilemap ;

: map@  ( col row -- tile )  tilebuf loc @ ;

: >gid  ( tile -- gid )  $0000fffc and 10 << ;

\ hex addressing
: hmap@  ( #col #row -- tile ) 2p map@ ;

include ramen/tiled1/collision

var onhitmap  \ XT;  ( info -- )  must be assigned to something to enable tilemap collision detection

\ map hitbox; exclusively for colliding with the TILEBUF; expressed in relative coords
var mbx  var mby  var mbw  var mbh

: onhitmap>  ( -- <code> ) r> code> onhitmap ! ;

: collide-objects-map  ( objlist tilesize -- )
    locals| tilesize |
    each>   x 2@  mbx 2@ x 2+!  onhitmap @ if  mbw 2@  tilesize  onhitmap @ collide-map  then
            x 2! ;

\ -------------------------------------------------------------------------------------------------
[section] tmx

$10000 include ramen/tiled1/tmx

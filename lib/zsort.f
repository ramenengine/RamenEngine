$000100 [version] zsort-ver

\ Z-sorted game objects

[undefined] rsort [if] $000100 include ramen/lib/rsort [then]

var zdepth

: #queued  ( addr -- addr cells )  here over - cell/ 1p ;
: zdepth@  's zdepth @ ;
: zsort  ['] zdepth@ rsort ;
: drawem  ( addr cells -- )  cells bounds do  i @ as  draw  cell +loop ;
: enqueue  ( objlist -- )  each>   hidden @ ?exit  me , ;

: drawzsorted  ( objlist -- )
    { >r  here dup  r> enqueue  #queued  2dup zsort  drawem  reclaim } ;

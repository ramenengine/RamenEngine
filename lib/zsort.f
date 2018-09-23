
\ Z-sorted game objects

require ramen/lib/rsort

var zdepth

: #queued  ( addr -- addr )  here swap - cell/ ;
: zdepth@  's zdepth @ ;
: zsort  ['] zdepth@ rsort ;
: drawem  ( addr cells -- )  cells bounds do  i @ as  draw  cell +loop ;
: enqueue  ( objlist -- )  each>   hidden @ ?exit  me , ;

: drawzsorted  ( objlist -- )
    { >r  here dup  r> enqueue  dup >r  #queued  2dup zsort  drawem  r> reclaim } ;

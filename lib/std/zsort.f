
\ Z-sorted game objects

depend ramen/lib/rsort.f

var zdepth

: zdepth@  's zdepth @ ;
: zsort  ['] zdepth@ rsort ;
: drawem  ( addr cells - )  cells bounds do  i @ as  draw  cell +loop ;
: enqueue  ( objlist - )  each> as  hidden @ ?exit  me , ;
: #queued  here swap - cell/ ;
: drawzsorted  ( objlist - ) here dup rot enqueue #queued 2dup zsort drawem reclaim ;

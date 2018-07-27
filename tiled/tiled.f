[section] preamble
\ Tiled module for RAMEN

\ -------------------------------------------------------------------------------------------------
[section] preamble

require ramen/lib/draw.f
require ramen/lib/array2d.f
require ramen/lib/buffer2d.f

[undefined] #MAXTILES [if] 10000 constant #MAXTILES [then]
include ramen/lib/tilemap.f

1024 1024 buffer2d: tilebuf 
create recipes #MAXTILES cellstack
create bitmaps 100 cellstack         \ single-image tileset's bitmaps

\ -------------------------------------------------------------------------------------------------
\ Tilemap objects
\ They don't allocate any buffers for map data.
\ A part of the singular buffer TILEBUF is located using the scrollx/scrolly values.

[section] tilemap

    var scrollx  var scrolly  \ used to define starting column and row!
    var w  var h              \ width & height in pixels
    var tbi                   \ tile base index

: /tilemap
    displaywh w 2!
    draw>
        tbi @ tilebase!
        at@ w 2@ clip>
            scrollx 2@  tsize scroll  tilebuf loc  tilebuf pitch@  tilemap ;

: /isotilemap
    draw>
        tbi @ tilebase!
        scrollx 2@  tsize scroll  tilebuf loc  tilebuf pitch@  50 50 isotilemap ;

: map@  ( col row -- tile )  tilebuf loc @ ;

: >gid  ( tile -- gid )  $0000fffc and 10 << ;

\ integer addressing
: hmap@  ( #col #row -- tile ) 2p map@ ;

\ Tilemap collision
include ramen/tiled/collision.f

var onhitmap   \ XT ( tile -- )

\ map hitbox; exclusively for colliding with the TILEBUF; expressed in relative coords
var mbx  var mby  var mbw  var mbh

: onhitmap>  ( -- <code> ) r> code> onhitmap ! ;  ( tile -- )

: ?'drop  ?dup ?exit  ['] drop ;

: collide-objects-map  ( objlist tilesize -- )
    locals| tilesize |
    each>   mbw 2@ or -exit
            onhitmap @ ?'drop is map-collide  tilesize  collide-map ;


\ -------------------------------------------------------------------------------------------------
[section] tmx

include ramen/tiled/tmx.f
also xmling  also tmxing

var gid
: @gidbmp  ( -- bitmap )  tiles gid @ [] @ ;

\ Image (background) object support (multi-image tileset) -----------------------------------------
: (loadbitmaps)  ( n -- dom )
    tmxtileset  locals| gid0 ts |
    ts eachelement> that's tile  dup tile>bmp  tiles rot id@ gid0 + [] ! ;

: load-bitmaps  ( n -- )  (loadbitmaps)  ?dom-free ;

\ Load a single-image tileset ---------------------------------------------------------------------
: load-tmxtileset  ( n -- ) \ load bitmap and split it up, adding it to the global tileset
    tmxtileset over tileset>bmp locals| bmp firstgid ts dom |
    bmp bitmaps push
    bmp  ts tilewh@  firstgid maketiles
    dom ?dom-free ;

\ don't execute this frequently!
: @tilesetwh  ( n -- tw th )  tmxtileset drop tilewh@ rot ?dom-free ;

\ Load a normal tilemap and convert it for RAMEN to be able to use --------------------------------
: de-Tiled  ( n -- n )
    dup 2 << over $80000000 and 1 >> or swap $40000000 and 1 << or ;

: load-tmxlayer  ( layer destarray2d destcol destrow -- )
    rot locals| tilebuf |
    3dup
        tilebuf loc  tilebuf pitch@ read-tmxlayer
        rot wh@ tilebuf some2d> cells bounds do   \ convert it!
            i @ de-Tiled i !
        cell +loop ;

\ Load object recipes from tileset ----------------------------------------------------------------
\ No images are loaded in this use case.
\ Instead we load any object recipes that aren't loaded.

\ Load object groups ------------------------------------------------------------------------------
\ This supports 3 kinds of objects that can be stored in TMX files.
\ 1) Regular scripted game objects where the tile gid points to a recipe XT in a table.
\ 2) Rectangular objects with no associated tile
\ 3) Background (image) objects where the gid points to a bitmap in the global tileset

\ You are responsible for assigning these DEFERs before calling LOAD-OBJECTS
\ They all can expect the pen has already been set to the XY position.

defer tmxobj   ( object-nnn XT -- )   \ XT is the TMX recipe for the object loaded from the script
defer tmxrect  ( object-nnn w h -- )
defer tmximage ( object-nnn gid -- )

: -recipes  ( -- )  recipes 0 [] #MAXTILES cells erase ;

\ : reload-recipes ;

\ Define a TMX recipe.  TMXING is in the search order while compiling.
\ All TMX recipe definitions are kept in the TMXING vocabulary.
get-order get-current
    define (;)   : ;   previous previous definitions  postpone ;   ; immediate
set-current set-order


0 value (rcp)
: :TMX  ( -- <name> )  ( object-nnn -- )  \ name must match the filename
    also (;)  also tmxing definitions
    >in @
    defined rot >in !  not if  drop create here to (rcp) 0 ,
                           else  >body to (rcp) then
    :noname (rcp) ! ;

\ LOADRECIPES
\ Conditionally load recipes that aren't defined and then stores them in RECIPES
\ Tile image source paths are important!  They correspond to the object script filenames!
\ When a tile does not have an image, it will load a recipe if the tile
\ has its TYPE set to something.

: uncount  drop #1 - ;
: (saveorder)  get-order  r> call  >r  set-order  r> ;
: >recipe  ( name c -- recipe|0 )
    \ cr 2dup type
    locals| c name |
    (saveorder)
    only tmxing  name c uncount  find  ( xt|a flag )  ?exit
    drop  objpath count s[  name c +s  s" .f" +s  ]s
        2dup file-exists 0= if  2drop 0 exit  then
        only forth definitions
        included  (rcp) ;

: (loadrecipe)  ( gid name c -- recipe|0 )  >recipe  dup rot recipes nth ! ;

: (loadrecipes)  tmxtileset  locals| firstgid |
    ( tileset ) eachelement> that's tile
        dup  id@ firstgid +  swap
            0 s" image" element ?dup if
                source@ -path -ext (loadrecipe) drop
            else
                ?type if  (loadrecipe) drop  else  ( gid ) drop  then
            then ;
: loadrecipes  ( map n -- )  (loadrecipes)  ?dom-free ;

: ?tmxobj  dup if  tmxobj  else  2drop  then ;

: loadobjects  ( objgroup -- )
    eachelement> that's object
        dup xy@ at
        dup rectangle? if
            dup ?type if  (loadrecipe) @ ( nnn xt )  ?tmxobj  exit then  \ rectangles with types are treated as game objects.
                                                                         \ you can get the dimensions from the xml element if needed.
            dup wh@ ( nnn w h ) tmxrect
        else
            dup gid@ dup  recipes nth @ ?dup if
                ( nnn gid recipe ) nip  @ ( nnn xt ) ?tmxobj
            else
                ( nnn gid ) tmximage
            then
        then
;

: -bitmaps  bitmaps #pushed for  bitmaps pop -bmp  loop ;

: open-map  ( path c -- )
    close-tmx  -recipes  -tiles  -bitmaps  open-tmx ;

: open-tilemap  ( path c -- )  \ doesn't delete any tiles; assumes static tileset
    close-tmx  -recipes  -bitmaps  open-tmx ;

only forth definitions

[section] preamble
\ Tiled module for RAMEN

\ -------------------------------------------------------------------------------------------------
[section] preamble

require ramen/lib/draw.f
require ramen/lib/array2d.f
require ramen/lib/buffer2d.f
require afkit/lib/stride2d.f

[undefined] #MAXTILES [if] 16384 constant #MAXTILES [then]  \ keep this a power of 2
include ramen/lib/tilemap.f

1024 1024 buffer2d: tilebuf 
create recipes #MAXTILES stack
create bitmaps 100 stack         \ single-image tileset's bitmaps
defer tileprops@   :noname drop 0 ; is tileprops@  ( tilecell -- bitmask )  

\ -------------------------------------------------------------------------------------------------
\ Tilemap objects
\ They don't allocate any buffers for map data.
\ A part of the singular buffer TILEBUF is located using the scrollx/scrolly values.

[section] tilemap

var scrollx  var scrolly  \ used to define starting column and row!
var w  var h              \ width & height in pixels
var tbi                   \ tile base index

: /tilemap
    viewwh w 2!
    draw>
        tbi @ tilebase!
        at@ w 2@ clip>
            scrollx 2@  tsize scrollofs  tilebuf loc  tilebuf pitch@  tilemap ;

: /isotilemap
    draw>
        tbi @ tilebase!
        scrollx 2@  tsize scrollofs  tilebuf loc  tilebuf pitch@  50 50 isotilemap ;

: map@  ( col row -- tile )  tilebuf loc @ ;

: >gid  ( tile -- gid )  $003fff000 and ;

\ Tilemap collision
include ramen/lib/tiled/collision.f

var onhitmap   \ XT ( tile -- )

\ map hitbox; exclusively for colliding with the TILEBUF; expressed in relative coords
var mbx  var mby  var mbw  var mbh

: onhitmap>  ( -- <code> ) r> code> onhitmap ! ;  ( tilecell -- )

: ?'drop  ?dup ?exit  ['] drop ;

: collide-objects-map  ( objlist tilesize -- )
    locals| tilesize |
    each>   mbw 2@ or -exit
            onhitmap @ ?'drop is map-collide  tilesize  collide-map ;


: (counttiles)    map@ tileprops@ (bm) and -exit  1 +to (count) ;
: counttiles  ( x y w h bitmask tilesize -- count )
    swap  to (bm)  0 to (count)  locals| ts h w y x |
    ['] (counttiles)  x ts / y ts /  w ts / 1 max h ts / 1 max  1 1 stride2d
    (count) ; 

\ -------------------------------------------------------------------------------------------------
[section] tmx

include ramen/lib/tiled/tmx.f
also xmling also tmxing  

var gid
: @gidbmp  ( -- bitmap )  tiles gid @ [] @ ;

\ Image (background) object support (multi-image tileset) -----------------------------------------
: (load-bitmaps)  ( tileset# -- dom )
    tmxtileset  locals| gid0 ts |
    ts eachelement> that's tile  dup tile>bmp tiles rot id@ gid0 + [] ! ;
: load-bitmaps  ( tileset# -- )
    (load-bitmaps)  ?dom-free ;

\ Load a single-image tileset ---------------------------------------------------------------------
: load-tmxtileset  ( tileset# -- ) \ load bitmap and split it up, adding it to the global tileset
    tmxtileset over tileset>bmp locals| bmp firstgid ts dom |
    bmp bitmaps push
    bmp  ts tilewh@  firstgid maketiles
    dom ?dom-free ;

\ don't execute this frequently!
: @tilesetwh  ( tileset# -- tw th )
    tmxtileset drop tilewh@ rot ?dom-free ;

\ Load a normal tilemap and convert it for RAMEN to be able to use --------------------------------
: de-Tiled  ( n -- n )
    dup 1p  over $80000000 and if #1 or then  swap $40000000 and if #2 or then ;

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
rolevar recipe
0 value (role) \ used when loading objects
: :recipe  ( role -- )  ( object-nnn -- )  \ note the role's name must match the filename
    also (;)  to (role) :noname (role) 's recipe !  ;

\ LOAD-RECIPES
\ Conditionally load recipes that aren't defined and then stores them in RECIPES wordlist
\ Tile image source paths are important!  They correspond to the object script filenames!
\ When an object does not have an image, it will load a recipe if the tile
\ has its TYPE set to something.

: uncount  drop #1 - ;
: (saveorder)  get-order  r> call  >r  set-order  r> ;
: >recipe  ( name c -- recipe|0 )
    locals| c name | (saveorder) only tmxing
    \ see if the recipe's role is already defined
    name c uncount  find  ( xt|a flag )  if  >body exit then   drop  
    \ load the script if it's in the obj/ folder
    objpath count s[  name c +s  s" .f" +s  ]s
        2dup file-exists 0= if  2drop 0 exit  then
        only forth definitions
        included  (role) ;

: (loadrecipe)  ( gid name c -- recipe|0 )  >recipe  dup rot recipes nth ! ;

: (loadrecipes)  tmxtileset  locals| firstgid |
    ( tileset ) eachelement> that's tile
        dup  id@ firstgid +  swap
            0 s" image" element ?dup if
                source@ -path -ext (loadrecipe) drop
            else
                obj?type if  (loadrecipe) drop  else  ( gid ) drop  then
            then ;
: load-recipes  ( tileset# -- )  (loadrecipes)  ?dom-free ;

: ?tmxobj  dup if  tmxobj  else  2drop  then ;

: load-objects  ( objgroup -- )
    eachelement> that's object
        dup xy@ at
        dup rectangle? if
            dup obj?type if  (loadrecipe) @ ( nnn xt )  ?tmxobj  exit then  
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

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

\ See ex/extilemap.f and ex/exearwig.f for examples
\ There are a various ways to use a Tiled map.  Let's break it down by data type.

\ Tilesets
\   A) Load source image and break it up into an array of subbitmaps for tilemap display.
\      (There is a global tile table provided in tilegame.f)
\      If your tilemap only uses one tileset you could get away with using afsubimg directly,
\      but you'd need to write your own tilemap-drawing routine.
\   B) Load multiple images (one-image-per-tile) into the same array, as normal bitmaps.
\      These bitmaps are then referenced indirectly by GID for display.
\   C) Don't load the images at all, just use the paths to instantiate objects sharing
\      the same base name.  (This is more convenient than using Tiled's "type" field.)

\ Tilemaps (called Layers in Tiled)
\   A) Reference by name and load into already-declared data structures.
\   B) Some kind of dynamic system (an array of data structures referenced by pointer VALUEs)

\ Object Groups (called Object Layers in Tiled)
\   A) You could ignore the separation of layers and just go through all objects instantiating them
\      into a single object list.  See Tilesets > C
\   B) Reference layers by name and instantiate objects into different object lists.
\   C) Some kind of dynamic system
\   D) Treat an object group as a "background layer" full of "tile" objects.  See Tilesets > B

\ How instantiation works:
\   RAMEN has no idea about "classes" so normally object instantiation is pretty open-ended.
\   Code that defines the creation of an object is called a recipe.
\
\   Object scripts are made map-editor-agnostic by using conditional compilation, increasing ease of
\   portability between projects - which could potentially be made with different map editors (or none at all!!!)
\
\   Here's an example:
\   : *myobjectmaker   ( ??? -- )  ( objlist )  ONE  ( initialization ) ;
\   [defined] tmx [if]
\       :tmx <myobjectname>  ( object-node -- )  ... *myobjectmaker ... ;
\   [then]
\
\   The body of the :TMX object loader would call your actual recipe.
\
\   Keep your object scripts in a subfolder of your project, and call it objects/.
\   The object group loader will then be able to find them.  It loads them on-demand.
\   The scripts will each only be loaded once.  You can reset the table that stores the loader vectors to
\   force an update.
\
\   You can also just INCLUDE the script you want to update.  If you use the Role system and :TMX , the object's
\   behavior and loader will be immediately altered, respectively.
\
\   Because your Forth's license might not permit on-the-fly compilation, you will be able to pre-compile all your
\   object scripts before publishing so this is mainly a development feature.


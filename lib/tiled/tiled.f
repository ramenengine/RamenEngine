\ Tiled module for RAMEN
depend ramen/lib/array2d.f
depend ramen/lib/buffer2d.f
depend ramen/lib/stride2d.f

[undefined] #MAXTILES [if] 16384 constant #MAXTILES [then]  \ keep this a power of 2
depend ramen/lib/std/tilemap.f

create roles #MAXTILES stack,
create bitmaps 100 stack,         \ single-image tileset's bitmaps
defer tmxobj   ( object-nnn role - )
defer tmxrect  ( object-nnn w h - )
defer tmximage ( object-nnn gid - )

var gid
rolevar recipe


\ Image (background) object support (multi-image tileset) -----------------------------------------
: load-bitmaps  ( tileset# - dom )
    tileset locals| gid0 ts |
    ts eachel> that's tile
        dup tile>bmp swap id@ gid0 + tiles [] !
        ?dom-free ;

\ don't execute this frequently!
: @tilesetwh  ( tileset# - tw th )
    tileset drop tilewh@ rot ?dom-free ;

\ Load a normal tilemap and convert it for RAMEN to be able to use --------------------------------
: de-Tiled  ( n - n )
    dup 1p  over $80000000 and if #1 or then  swap $40000000 and if #2 or then ;

: load-tmxlayer  ( layer destarray2d destcol destrow - )
    rot locals| tilebuf |
    3dup
        tilebuf loc  tilebuf pitch@ read-tmxlayer
        rot wh@ tilebuf some2d> cells bounds do   \ convert it!
            i @ de-Tiled i !
        cell +loop ;

\ Load object roles from tileset ----------------------------------------------------------------
\ No images are loaded in this use case.
\ Instead we load any scripts that aren't loaded.

\ Load object groups ------------------------------------------------------------------------------
\ This supports 3 kinds of objects that can be stored in TMX files.
\ 1) Regular scripted game objects where the tile gid points to a role in a table.
\ 2) Rectangular objects with no associated tile
\ 3) Environment (image) objects where the gid points to a bitmap in the global tileset

: /roles  ( - )  0 roles [] #MAXTILES cells erase ;

: /roles  ( - )  0 roles [] #MAXTILES cells erase ;

\ : reload-recipes ;

\ You don't have to define a recipe.  The last defined role will be used.
\ note the role's name must match the filename
: :recipe  ( role - )  :noname swap 's recipe !  ;

\ LOAD-SCRIPTS
\ Conditionally load the scripts associated with any roles that aren't defined.

\ Tile image source paths are important!  They correspond to the object script filenames!

\ If an object does not have an associated image, this loads a script corresponding
\ to its Type attribute if it has one.

create $$$ #256 allot
: uncount  $$$ place $$$ ;
: (saveorder)  get-order  r> call  >r  set-order  r> ;
: >script  objpath count s[  +s  s" .f" +s  ]s ;
: load-script  ( name c - role|0 )
    locals| c name | 
    \ see if the role is already defined
    name c uncount  find  ( xt|a flag ) if  >body exit then   drop  
    \ load the script if it's in the obj/ folder and return the last defined role 
    name c >script 
    cr ." Loading script: " 2dup type
    2dup file-exists    0= if  2drop 0 exit  then
        included  lastrole @ ;

: script!  ( role n )  roles [] ! ;
\ 
\ : (load-scripts)  tileset ( dom tileset gid )  locals| firstgid |
\     ( tileset ) eachel> that's tile
\         dup id@ firstgid +  swap  ( gid nnn )
\             dup 0 s" image" element ?dup if
\                 nip source@ -path -ext load-script swap script!  drop
\             else
\                 el?type if  load-script swap script!  else  ( gid ) drop  then
\             then ;
\ 
\ \ You can load all of the current map's scripts ahead of time
\ \ (but you don't have to.)
\ : load-scripts  ( tileset# - )  (load-scripts)  ?dom-free ;
 
: ?tmxobj  dup if tmxobj else 2drop then ;

: load-objects  ( objgroup - )
    eachel> that's object 
        dup xy@ at
        dup rectangle? if
            dup el?type if  load-script ( nnn role|0 ) ?tmxobj  exit then  
            dup wh@ ( nnn w h ) tmxrect
        else
            dup gid@ dup  roles [] @ ?dup if
                ( nnn gid role|0 ) nip ( nnn role|0 ) ?tmxobj
            else
                ( nnn gid ) tmximage
            then
        then
;

\ Load a single-image tileset ---------------------------------------------------------------------
: load-tileset  ( tileset# - ) \ load bitmap and split it up, adding it to the global tileset
    tileset over tileset>bmp locals| bmp firstgid ts dom |
    bmp bitmaps push
    bmp ts tilewh@ firstgid maketiles
    dom ['] ?dom-free >code >r
    \ load any scripts (tiles that have a Type property)
    ts eachel> that's tile  
        dup el?type if load-script firstgid rot id@ + script!
        else drop then
    ; 

: -bitmaps  bitmaps length for  bitmaps pop -bmp  loop ;

: open-map  ( path c - )
    close-tmx  /roles  -tiles  -bitmaps  open-tmx ;

: open-tilemap  ( path c - )  \ doesn't delete any tiles; assumes static tileset
    close-tmx  /roles  -bitmaps  open-tmx ;

only forth definitions

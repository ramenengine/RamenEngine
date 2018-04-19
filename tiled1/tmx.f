\ TMX (Tiled) support
\ This just provides access to the data and some conversion tools
\ It directly supports only a subset of features
\  - Object groups
\  - Single and Multiple image tilesets
\  - Tilemaps in Base64 uncompressed format (sorry no zlib, maybe later)
\  - Rectangles
\  - Referenced tileset files - in fact in an effort to salvage my sanity embedded tilesets are NOT supported.  Sorry.  (You ought to be using external tilesets anyway. ;)
\  - Layer Groups are NOT supported.  Sorry.

\ TODO
\  [ ] - Custom Properties
\  [ ] - Other shapes besides rectangle
\  [ ] - Add custom property to allow some tile images not to be loaded since they're for the editor only and would waste RAM

\ You can access one TMX file at a time.
\ To preserve global ID coherence, when you load the tiles of a TMX file, ALL tileset nodes are loaded
\ into the system, freeing what was there before.  To mitigate loading time I might implement asset caching or preloading
\ at some point...

: b64,  ( base64-src count -- )
    str-new >r  r@ b64-decode here over allot swap move  r> str-free ;

only forth definitions also xmling

0 value mapnode
0 value (code)

100 cellstack: tilesetdoms
100 cellstack: layernodes
100 cellstack: objgroupnodes
200 cellstack: tilesets  \ firstgid , tileset element , first gid , tileset element , ...

0 value lasttmx
create tmxdir  256 allot

: aggregate  ( node adr c cellstack -- )  locals| cs c a |
    cs 0 truncate  a c xmlfirst begin  ?dup while  dup cs push  a c  xmlnext repeat ;

: load-objectgroups  mapnode " objectgroup" objgroupnodes aggregate ;

: load-layers  mapnode " layer" layernodes aggregate ;

\ shortcuts to access properties of several node types:
only forth definitions also xmling
define tmxing

    : @source   " source" xmlvalue ;
    : @nameattr " name" xmlvalue ;
    : ?name     " name" xmlvalue ?dup ;
    : @w        " width" xmlvalue evaluate ;
    : @h        " height" xmlvalue evaluate ;
    : @wh       dup @w swap @h ;
    : @id       " id" xmlvalue evaluate ;
    : @x        " x" xmlvalue evaluate ;
    : @y        " y" xmlvalue evaluate ;
    : @xy       dup @x swap @y ;
    : ?type     " type" xmlvalue ?dup ;


    \ Opening a TMX
    : !dir  2dup 2dup [char] / [char] \ replace-char  -name  #1 +  ( add the trailing slash )  tmxdir place ;
    : +dir  tmxdir count 2swap strjoin ;

only forth definitions also xmling also tmxing

: >tsx  @source +dir 2dup cr type loadxml ;
: +tileset  ( firstgid tileset -- )
    dup tilesetdoms push  " tileset" >first  swap tilesets push  tilesets push ;

: load-tilesets
    tilesetdoms scount for  @+ dom-free  loop drop
    tilesetdoms 0 truncate
    tilesets 0 truncate
    mapnode " tileset" eachel> dup " firstgid" attr  swap >tsx +tileset ;

: >map   " map" >first 0= abort" Not a valid TMX file" ;
: closetmx  lasttmx ?dup -exit dom-free  0 to lasttmx ;

: opentmx  ( path c -- )
    !dir  closetmx  loadxml dup to lasttmx  >map to mapnode  load-tilesets  load-layers  load-objectgroups ;


\ Tilesets!
\ "tileset" really refers to a 2 cell data structure defined above, in TILESETS.
: tileset[]  2 * tilesets nth ;
: multi-image?  ( tileset -- flag )  cell+ @ " image" xmlfirst 0= ;
: @firstgid  ( tileset -- gid )  @ ;
: single-image  ( tileset -- path c )  cell+ @ " image" xmlfirst @source +dir ;
: tile-gid  ( tileset n -- gid )  over @firstgid >r  >r >el " tile" r> child @id  r> + ;
: tile-image  ( tileset n -- imagepath c )  >r cell+ @  " tile" r> child " image" 0 child @source +dir ;
: tile-dims  ( tileset -- w h )  >el dup " tilewidth" attr swap " tileheight" attr ;
: (tiles)  " tile" eachel>  (code) call ;
: tiles>  ( tileset -- <code> )  >el  r>  (code) >r  to (code)  (tiles) r> to (code) ;

\ Layers!
: layer[]  layernodes nth @ ;
: ?layer  ( name c -- layer-node | 0 )  \ find layer by name
    locals| c n |
    #layers for
        i layer[]  @name  n c compare 0= if
            i layer[]  unloop exit
        then
    loop  0 ;
: extract-tile-layer  ( layer dest pitch -- )  \ read out tilemap data. you'll probably need to process it.
    third @wh locals| h w pitch dest |  ( layer )
    here >r
        " data" xmlfirst  xmltext  b64, \ Base64, no compression!!!
        r@  w cells  dest  pitch  h  w cells  2move
    r> reclaim ;
: (layers)  mapnode xmleach> " layer" ?xml -exit over call ;
: layers>  ( -- <code> )  ( node -- )  r> (layers) drop ;


\ Object groups!
: objgroup[]  objgroupnodes nth @ ;
: ?objgroup  ( name c -- objgroup-node | 0 )  mapnode -rot >first ;
: @gid  " gid" xmlattr evaluate $0fffffff and ;
: @rotation  " rotation" xmlvalue not if 0 else evaluate then ;
: @visible  " visible" xmlvalue if evaluate 0<> then ;
: @vflip  " gid" xmlvalue evaluate $40000000 and 0<> ;
: @hflip  " gid" xmlvalue evaluate $80000000 and 0<> ;
: rectangle?  " gid" xmlvalue dup if nip nip then  not ;  \ doesn't actually guarantee it's not some other shape, because TMX is stupid.  so check for those first...
: (objects)  xmleach> " object" ?xml -exit over call ;
: objects>  ( node -- <code> )  ( node -- )  r> swap (objects) drop ;
: (objgroups)  mapnode xmleach> " objectgroup" ?xml -exit over call ;
: objgroups>  ( -- <code> )  ( node -- )  r> (objgroups) drop ;


only forth definitions
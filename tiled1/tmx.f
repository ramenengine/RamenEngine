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

100 cellstack tilesetdoms
100 cellstack layernodes
100 cellstack objgroupnodes

200 cellstack tilesets  \ firstgid , tileset element , first gid , tileset element , ...

0 value lasttmx
create tmxdir  256 allot

: load-objectgroups  objgroupnodes 0 truncate  mapnode " objectgroup" eachel> objgroupnodes push ;

: load-layers  layernodes 0 truncate  mapnode " layer" eachel> layernodes push ;

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

previous definitions also tmxing

: >tsx  @source +dir 2dup cr type loadxml ;
: +tileset  ( firstgid tileset -- )
    dup tilesetdoms push  >root " tileset" 0 child  swap tilesets push  tilesets push ;

: load-tilesets
    tilesetdoms scount for  @+ dom-free  loop drop
    tilesetdoms 0 truncate
    tilesets 0 truncate
    mapnode " tileset" eachel> dup " firstgid" attr  swap >tsx +tileset ;

: >map   " map" >first 0= abort" File is not a recognized TMX file!" ;
: closetmx  lasttmx ?dup -exit dom-free  0 to lasttmx ;

: opentmx  ( path c -- )
    !dir  closetmx  loadxml dup to lasttmx  >root >map to mapnode  load-tilesets  load-layers  load-objectgroups ;


\ Tilesets!
\ "tileset" really refers to a 2 cell data structure defined above, in TILESETS.
: #tilesets  tilesetdoms #pushed ;
: tileset[]  2 * tilesets nth ;
    : >el  cell+ @ ;
: multi-image?  ( tileset -- flag )  >el " image" 0 child? not ;
: @firstgid  ( tileset -- gid )  @ ;
: single-image  ( tileset -- path c )  >el " image" 0 child @source +dir ;
: @tilecount  ( tileset -- n )  >el " tilecount" attr ;
: tile-gid  ( tileset n -- gid )  over @firstgid >r  >r >el " tile" r> child @id  r> + ;
: tile-image  ( tileset n -- imagepath c )  >r >el " tile" r> child " image" 0 child @source +dir ;
: tile-dims  ( tileset -- w h )  >el dup " tilewidth" attr swap " tileheight" attr ;
: (tiles)  " tile" eachel>  (code) call ;
: tiles>  ( tileset -- <code> )  >el  r>  (code) >r  to (code)  (tiles) r> to (code) ;

\ Layers!
: #layers  layernodes #pushed ;
: layer[]  layernodes nth @ ;
: ?layer  ( name c -- layer-node | 0 )  \ find layer by name
    locals| c n |
    #layers for
        i layer[]  @name  n c compare 0= if
            i layer[]  unloop exit
        then
    loop  0 ;
: extract  ( layer dest pitch -- )  \ read out tilemap data. you'll probably need to process it.
    third @wh locals| h w pitch dest |  ( layer )
    here >r
        " data" 0 child  >text  b64, \ Base64, no compression!!!
        r@  w cells  dest  pitch  h  w cells  2move
    r> reclaim ;
: layers>  ( -- <code> )  ( layernode -- )
    r>  (code) >r  to (code)  " layer" eachel>  (code) call  r> to (code) ;


\ Object groups!
: #objgroups  objgroupnodes #pushed ;
: objgroup[]  objgroupnodes nth @ ;
: ?objgroup  ( name c -- objgroup-node | 0 )  \ find object group by name
    locals| c n |
    #objgroups for
        i objgroup[]  xmlname  n c compare 0= if
            i objgroup[]  unloop exit
        then
    loop  0 ;
: @gid  " gid" attr $0fffffff and ;
: @rotation  " rotation" ?attr not if 0 then ;
: @visible  " visible" ?attr if 0<> else true then ;
: @vflip  " gid" attr $40000000 and 0<> ;
: @hflip  " gid" attr $80000000 and 0<> ;
: rectangle?  " gid" ?attr dup if nip then  not ;  \ doesn't actually guarantee it's not some other shape, because TMX is stupid.  so check for those first...
\ : polygon? ;
\ : ellipse? ;
\ : polyline? ;
: (objects)  " object" eachel>  (code) call ;
: objects>  ( objgroup -- <code> )  ( objectnode -- )  r>  (code) >r  to (code)  (objects) r> to (code) ;
: (objgroups)  mapnode " objectgroup" eachel>  (code) call ;
: objgroups>  ( -- <code> )  ( objectgroupnode -- )  r>  (code) >r  to (code)  (objgroups)  r> to (code) ;

only forth definitions
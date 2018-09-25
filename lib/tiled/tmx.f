
\ TMX (Tiled) support
\ This just provides convenient data access and loading of "normal" tilemap layers
\ It directly supports only a subset of features
\  - Object groups
\  - Single and Multiple image tilesets
\  - Tilemaps in Base64 uncompressed format
\  - Rectangles
\  - Embedded tilesets and Referenced tileset files

\ TODO
\  [x] - Custom Properties (<properties><property>)
\  [ ] - Animations (<tile><animation><frame>)
\  [ ] - Other shapes besides rectangles (<ellipse>, <path>, <polyline>, <point>)
\  [ ] - Text (<text>)
\  [ ] - Compressed layers (with zlib... it's simple)
\  [ ] - Image layers (<imagelayer>)
\  [ ] - Group layers (<group>)

require afkit/lib/xml

: base64  ( base64-src count -- str )   str-new >r  r@ b64-decode 2drop  r> ;

only forth definitions
define tmxing
    xmling also tmxing

    : source@   s" source" val ;
    : source?   s" source" attr? ;
    : name@     s" name" val ;
    : ?name     s" name" val ?dup 0<> ;
    : value@    s" value" val ;
    : w@        s" width" pval ;
    : h@        s" height" pval ;
    : wh@       dup w@ swap h@ ;
    : x@        s" x" pval ;
    : y@        s" y" pval ;
    : xy@       dup x@ swap y@ ;
    : el?type  dup s" type" attr? if  s" type" val  true  else  drop  false then ;
    : firstgid@ s" firstgid" pval ;
    : gid@      s" gid" pval ;
    : id@       s" id" pval ;
    : rotation@ s" rotation" pval ;
    : visible@  s" visible" pval ;
    : hflip@    s" gid" ival $80000000 and ;
    : vflip@    s" gid" ival $40000000 and ;
    : flip@  dup hflip@ 0<> #1 and swap vflip@ 0<> #2 and or ;
    : orientation@  s" orientation" val ;
    : backgroundcolor?  s" backgroundcolor" attr? ;
    : backgroundcolor@  s" backgroundcolor" val [char] $ third c! evaluate ;
    : tilew@  s" tilewidth" pval ;
    : tileh@  s" tileheight" pval ;
    : tilewh@  dup tilew@ swap tileh@ ;
    : tilecount@  s" tilecount" pval ;
    : spacing@  s" spacing" pval ;
    : margin@   s" margin" pval ;
    : >data     0 s" data" element ;

    create tmxpath  #256 allot
    create tsxpath  #256 allot
    create objpath  #256 allot

    : tmxpath+  tmxpath count 2swap strjoin ;
    : tsxpath+  tsxpath @ -exit  tsxpath count 2swap strjoin ;

    : tileset>source  ( tileset -- dom tileset )  \ path should end in a slash
        source@ slashes tmxpath+  2dup -filename tsxpath place  loadxml 0 s" tileset" element ;

    : ?dom-free  ?dup -exit dom-free ;

    : #objects  ( objgroup -- n )  s" object" #elements ;
    : #images   ( tileset -- n )  s" image" #elements ;

    : tile>bmp  ( tile-nnn -- bitmap | 0 )  \ uses TSXPATH
        0 s" image" element dup -exit  source@ slashes tsxpath+  zstring al_load_bitmap ;
    : tileset>bmp  ( tileset-nnn -- bitmap )  tile>bmp ;  \ it's the same

    : rectangle?  ( object -- flag )  s" gid" attr? not ;
    \ Note RECTANGLE? is needed because TMX is stupid and doesn't have a <rectangle> element.

only forth definitions also xmling also tmxing

include ramen/lib/tiled/tmxz.f

0 value map
0 value tmx
:noname  0 to map  0 to tmx  ; loadtrig  \ initialize these on game load

: strip  2over 2swap search if drop nip over - else 2drop then ;
: >objpath  s" data" strip s" obj/" strjoin  slashes ;

only forth definitions also xmling also tmxing

: tileset  ( n -- dom|0 tileset gid )  \ side-effect: TSXPATH is set or cleared
    map swap s" tileset" element
        dup source? if   dup tileset>source  rot firstgid@
                    else  0 swap dup firstgid@  tmxpath count tsxpath place then ;
: #tilesets  ( -- n )  map s" tileset" #elements ;
: find-tileset#   ( filename c -- n )  \ find a tileset by filename (source attribute)
    locals| c adr |
    #tilesets for
        map i s" tileset" element
            source@ adr c $= if i unloop exit then
    loop  -1 abort" Tileset not found." ;

: #objgroups ( -- n )  map s" objectgroup" #elements ;
: objgroup ( n -- objgroup ) map swap s" objectgroup" element ;
: find-objgroup   ( name c -- dom-nnn )
    locals| c adr |
    #objgroups for
        i objgroup dup 
            name@ adr c $= if unloop exit then
            drop
    loop  -1 abort" Object group not found." ;
    
: #tmxlayers ( -- n )  map s" layer" #elements ;
: tmxlayer ( n -- layer ) map swap s" layer" element ;
: find-tmxlayer   ( name c -- layer )
    locals| c adr |
    #tmxlayers for
        i tmxlayer dup
            name@ adr c $= if unloop exit then
        drop
    loop  -1 abort" Tilemap layer not found." ;

: property  ( element str c -- adr c true | false )
    0 locals| props c str el |
    el 0 s" properties" element dup -exit  to props
    props s" property" #elements for
        props i s" property" element  dup  name@ str c $= if
            value@  true  unloop exit
        else  drop  then
    loop  false ;

: open-tmx    ( path c -- )
    slashes findfile
    2dup -filename  2dup tmxpath place  2dup tsxpath place
    >objpath objpath place
    loadxml  swap to tmx  0 s" map" element to map  ;

: close-tmx   tmx ?dom-free  0 to map ;

only forth definitions 
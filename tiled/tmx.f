
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

only forth definitions also xmling
define tmxing

    : source@   " source" val ;
    : source?   " source" attr? ;
    : name@     " name" val ;
    : ?name     " name" val ?dup 0<> ;
    : value@     " value" val ;
    : w@        " width" pval ;
    : h@        " height" pval ;
    : wh@       dup w@ swap h@ ;
    : x@        " x" pval ;
    : y@        " y" pval ;
    : xy@       dup x@ swap y@ ;
    : ?type     dup " type" attr? if  " type" val  true  else  drop  false then ;
    : firstgid@ " firstgid" pval ;
    : gid@      " gid" pval ;
    : id@       " id" pval ;
    : rotation@ " rotation" pval ;
    : visible@  " visible" pval ;
    : hflip@    " hflip" pval ;
    : vflip@    " vflip" pval ;
    : orientation@  " orientation" val ;
    : backgroundcolor?  " backgroundcolor" attr? ;
    : backgroundcolor@  " backgroundcolor" val [char] $ third c! evaluate ;
    : tilew@  " tilewidth" pval ;
    : tileh@  " tileheight" pval ;
    : tilewh@  dup tilew@ swap tileh@ ;
    : tilecount@  " tilecount" pval ;
    : spacing@  " spacing" pval ;
    : margin@   " margin" pval ;
    : >data     0 " data" element ;

    : #tilesets  ( map -- n )  " tileset" #elements ;

    create tmxpath  #256 allot
    create tsxpath  #256 allot
    create objpath  #256 allot

    : tmxpath+  tmxpath count 2swap strjoin ;
    : tsxpath+  tsxpath @ -exit  tsxpath count 2swap strjoin ;

    : tileset>source  ( tileset -- dom tileset )  \ path should end in a slash
        source@ slashes tmxpath+  2dup -filename tsxpath place  loadxml 0 " tileset" element ;

    : ?dom-free  ?dup -exit dom-free ;

    : #objects  ( objgroup -- n )  " object" #elements ;
    : #images   ( tileset -- n )  " image" #elements ;

    include ramen/tiled/tmxz.f

    : tile>bmp  ( tile-nnn -- bitmap | 0 )  \ uses TSXPATH
        0 " image" element dup -exit  source@ slashes tsxpath+  zstring al_load_bitmap ;
    : tileset>bmp  ( tileset-nnn -- bitmap )  tile>bmp ;  \ it's the same

    : rectangle?  ( object -- flag )  " gid" attr? not ;
    \ Note RECTANGLE? is needed because TMX is stupid and doesn't have a <rectangle> element.

only forth definitions also xmling also tmxing

   0 value map
   0 value tmx

: tmxtileset  ( n -- dom|0 tileset gid )  \ side-effect: TSXPATH is set or cleared
    map swap " tileset" element
        dup source? if   dup tileset>source  rot firstgid@
                    else  0 swap dup firstgid@  tmxpath count tsxpath place then ;

: #objgroups ( -- n )  map " objectgroup" #elements ;
: objgroup ( n -- objgroup ) map swap " objectgroup" element ;
: find-objgroup   ( name c -- dom-nnn | 0 )
    locals| c adr |
    map #objgroups for
        map objgroup
            dup name@  adr c  compare 0= if  unloop  exit  then
            drop
    loop  0 ;

: #tmxlayers ( -- n )  map " layer" #elements ;
: tmxlayer ( n -- layer ) map swap " layer" element ;
: find-tmxlayer   ( name c -- layer | 0 )
    locals| c adr |
    map #tmxlayers for
        map i tmxlayer  dup
            name@  adr c  compare 0= if  unloop  exit  then
        drop
    loop  0 ;

: property  ( element str c -- adr c true | false )
    0 locals| props c str el |
    el 0 " properties" element dup -exit  to props
    props " property" #elements for
        props i " property" element  dup  name@ str c compare 0= if
            value@  true  unloop exit
        else  drop  then
    loop  false ;

: >objpath  " data/" search drop " objects/" strjoin  slashes ;

: open-tmx    ( path c -- )
    slashes findfile
    2dup -filename  2dup tmxpath place  2dup tsxpath place
    >objpath objpath place
    loadxml  swap to tmx  0 " map" element to map  ;

: close-tmx   tmx ?dom-free  0 to map ;

only forth definitions

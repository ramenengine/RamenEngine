$10000 [version] tmx-ver

\ TMX (Tiled) support
\ This just provides convenient data access and loading of "normal" tilemap layers
\ It directly supports only a subset of features
\  - Object groups
\  - Single and Multiple image tilesets
\  - Tilemaps in Base64 uncompressed format
\  - Rectangles
\  - Embedded tilesets and Referenced tileset files

\ TODO
\  [ ] - Custom Properties (<properties><property>)
\  [ ] - Animations (<tile><animation><frame>)
\  [ ] - Other shapes besides rectangles (<ellipse>, <path>, <polyline>, <point>)
\  [ ] - Text (<text>)
\  [ ] - Compressed layers (with zlib... it's simple)
\  [ ] - Image layers (<imagelayer>)
\  [ ] - Group layers (<group>)

[undefined] xml-ver [if] $000100 include kit/lib/xml [then]

: base64  ( base64-src count -- str )   str-new >r  r@ b64-decode 2drop  r> ;

only forth definitions also xmling
define tmxing

    : source@   " source" val ;
    : source?   " source" attr? ;
    : name@     " name" val ; ;
    : ?name     " name" val ?dup 0<> ;
    : w@        " width" pval ;
    : h@        " height" pval ;
    : wh@       dup w@ swap h@ ;
    : x@        " x" pval ;
    : y@        " y" pval ;
    : xy@       dup x@ swap y@ ;
    : ?type     " type" val ?dup 0<> ;
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

    : #tilesets  ( map -- n )  " tileset" #elements ;

    create tmxpath  256 allot

    : tmxpath+  tmxpath count 2swap strjoin ;

    : tileset>source  ( tileset -- dom tileset )  \ path should end in a slash
        source@ tmxpath+ loadxml 0 " tileset" element ;

    : tileset  ( map n -- dom|0 tileset gid )
        " tileset" element
        dup source? if   dup tileset>source rot firstgid@
                    else  0 swap dup firstgid@  then ;

    : ?dom-free  ?dup -exit dom-free ;

    : #objgroups ( map -- n )  " objectgroup" #elements ;
    : objgroup[] ( map n -- objgroup ) " objectgroup" element ;
    : objgroup   ( map adr c -- dom-nnn | 0 )
        locals| c adr map |
        map #objgroups for
            map i objgroup[]  dup
                name@  adr c  compare 0= if  unloop  exit  then
            drop
        loop  0 ;

    : #layers ( map -- n )  " layer" #elements ;
    : layer[] ( map n -- layer ) " layer" element ;
    : layer   ( map adr c -- layer | 0 )
        locals| c adr map |
        map #layers for
            map i layer[]  dup
                name@  adr c  compare 0= if  unloop  exit  then
            drop
        loop  0 ;

    : #objects  ( objgroup -- n )  " object" #elements ;
    : #images   ( tileset -- n )  " image" #elements ;

    : readlayer  ( layer dest pitch -- )  \ read out tilemap data. (GID'S)  Base64 uncompressed only
        third wh@ locals| h w pitch dest |  ( layer )
        0 " data" element text base64 >r
        r@ str-get drop  w cells  dest  pitch  h  w cells  2move
        r> str-free ;

    : tile>bmp  ( tile-nnn -- bitmap )  0 " image" element source@ tmxpath+ zstring al_load_bitmap ;
    : tileset>bmp  ( tileset-nnn -- bitmap )  tile>bmp ;  \ it's the same

    : rectangle?  ( object -- flag )  " gid" attr? not ;
    \ Note RECTANGLE? is needed because TMX is stupid and doesn't have a <rectangle> element.

only forth definitions also xmling also tmxing

: loadtmx    ( adr c -- dom map )
    2dup -filename tmxpath place
    loadxml 0 " map" element ;

only forth definitions

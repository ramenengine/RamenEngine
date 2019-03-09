\ zlib compression support for Tiled files
\ only zlib is supported, if it's neither uncompressed or zlib an error will be thrown

: layersize ( layer - #size )  wh@ swap cells * ;

: compressed?  ( layer - flag )
    >data
    dup s" compression" attr? not if  drop  false  exit then
    s" compression" val s" zlib" $= ?dup ?exit
    -1 abort" Error in COMPRESSED? : Only zlib compression is supported." ;

: buf  layersize allocate throw ;

: read-tmxlayer  ( layer dest pitch - )  \ read out tilemap data. (GID'S)
    third wh@ 0 locals| str h w pitch dest layer |
    layer >data text base64 to str
    layer compressed? if
        layer buf >r
            str str-get  r@  layer layersize  decompress drop
            r@  w cells  dest  pitch  w cells  h  2move
        r> free throw
    else
        str str-get drop  w cells  dest  pitch  w cells  h  2move
    then
    str str-free ;

\ zlib compression support for Tiled files
\ only zlib is supported, if it's neither uncompressed or zlib an error will be thrown

: layersize ( layer-nnn -- #bytes# )  wh@ cells ;
: compressed?  ( layer-nnn -- flag )
    dup " compression" attr? not if  drop  false  exit then
    " compression" val " zlib" compare 0= ?dup ?exit
    -1 abort" Error in COMPRESSED? : Only zlib is supported!" ;


\ zlib compression support for Tiled files
\ only zlib is supported, if it's neither uncompressed or zlib an error will be thrown

: layersize ( layer-nnn -- #bytes# )  wh@ cells ;
: compressed?  ( layer-nnn -- flag )


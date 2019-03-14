( load the map )

: reload
    s" level01.buf" >data 0 0 tilebuf loc 512 512 * cells @file
    0 tilebank 16 16 288 256 dimbank 
    s" tiles.png" >data 0 0 loadtiles
\        s" objects1" find-objgroup my-handlers load-objects  \ load object layer
;
reload

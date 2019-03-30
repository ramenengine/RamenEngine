( load the map )

: reload
    s" level01.buf" >data tilebuf count2d @file
    0 0 at s" tiles.png" >data loadtiles
\        s" objects1" find-objgroup my-handlers load-objects  \ load object layer
;
reload

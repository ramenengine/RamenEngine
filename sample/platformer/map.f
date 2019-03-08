( load the map )
also xmling also tmxing 
: handle-rectangle  ( nnn w h -- )
    2drop
    \ Get the starting position:
    dup s" name" attr? if dup name@ s" start" $= if dup xy@ startxy 2! then then
    drop
;
previous previous

create my-handlers
    0 , 0 , ' handle-rectangle ,

: reload
    -tiles -bitmaps 
    s" level01.tmx" >data open-map
        s" layer1" find-tmxlayer tilebuf 0 0 load-tmxlayer   \ load tilemap layer
        s" tiles.tsx" find-tileset# load-tileset             \ load tileset
        s" objects1" find-objgroup my-handlers load-objects  \ load object layer
;
reload

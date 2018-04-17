\ Load tilemap and objects
\  2 arrays store unique tile bitmaps, and object initializers.
\  A hook lets you do extra stuff per tile such as gather collision data.

defer onloadtile  ( tilenode -- )  ' drop is onloadtile
16384 cellstack bitmaps
0 value ts
create tempimg  /image /allot
16384 cellstack initializers

var gid
augment

\ Deferred words.
\ They can all assume ONE has just been called.
\ They can also assume the GID has already been set; same for HIDE (=0).

defer onmapload  ' execute is onmapload  ( initializer -- )  \ executes the initializer (or not)
defer obj  ' noop  is obj   ( -- )  \ default initializer when type isn't specified
defer box  ' 2drop is box  ( w h -- )

\ MAKE-INITIALIZERS
\ make array of initializer XT's.  if the object has a "type", iit's
\ looked up in the dictionary and if it exists we get the XT and put it in the array.
\ if it doesn't exist or if the "type" is not defined we use ' *OBJ
\ no need to TRUNCATE INITIALIZERS since we'll be using GID's as indices.
\ if a tile element doesn't exist at all we of course use ' *OBJ then too.

: (defaults)  ts @tilecount for  ['] obj  ts @firstgid i +  initializers [] !  loop ; \ default all to OBJ

: make-initializers  ( -- )
    (defaults)
    ts tiles>  ( tile-node )  >r                                        \ process any tile nodes
        r@ ?type if  uncount find not if  drop bright cr ." ERROR evaluating tile type, continuing..." normal ['] obj  then
               else  ['] obj  then
        ts @firstgid  r@ @id +  initializers nth !
        r@ onloadtile
    r> drop
;

: get-tile-image
    >r  tempimg ts r@ tile-image load-image
    tempimg bmp @ ts r> tile-gid tiles nth !
    tempimg bmp @ bitmaps push ;

: get-tileset-image
    tempimg ts single-image load-image
    tempimg ts tile-dims ts @firstgid change-tiles
    tempimg bmp @ bitmaps push ;

: load-tiles
    bitmaps scount for  @+ -bmp  loop drop  bitmaps 0 truncate
    clear-tiles
    #tilesets for
        i tileset[] to ts
        cr ts >el x.
        ts multi-image? if    \ might not work with "weird" tilesets ... if anyone even does that kind of thing
            \ add tiles that use their own image files
            ts @tilecount for  i get-tile-image  loop
        else
            \ add tiles from single image
            get-tileset-image
        then
        make-initializers
    loop ;

: load-objects  ( objgroup-node -- )
    dup cr x.
    \ get the destination objlist first
    dup @nameattr ['] evaluate catch if
        2drop objects  bright ." ERROR evaluating object group name (objlist), continuing..." normal
    then  in
    objects> >r
        cr r@ x.
        r@ @xy at
        r@ ?name if
            ['] evaluate catch if  bright ." ERROR evaluating object name, continuing..." normal then
        else
            r@ rectangle? not if
                ONE  r@ @gid gid !
                r@ @visible not hide !
                gid @ initializers [] @ ONMAPLOAD
            else
                r@ @wh ONE BOX
            then
        then
    r> drop ;

\ : load-all-objects ;


: convert-tile   dup 2 << over $80000000 and 1 >> or swap $40000000 and 1 << or ;
: convert-tilemap  ( col row #cols #rows array2d -- )
    some2d> cells bounds do i @ convert-tile i ! cell +loop ;

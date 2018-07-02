empty
    0 0 0 include ramen/brick
    include ramen/tiled/tiled
    include ramen/lib/stage

#1 to #globalscale
stage 1000 pool: layer0

\ ------------------------------------------------------------------------------------------------
\ Load map

" ramen/test/sticker-knight/sandbox.tmx" loadtmx  constant map  constant dom
only forth definitions also xmling also tmxing

map 0 loadbitmaps
map 0 loadrecipes

:is tmxobj ( object-nnn XT -- )  over ?type if cr type then  execute ;
:is tmxrect ( object-nnn w h -- )  .s 3drop ;
:is tmximage ( object-nnn gid -- )
    layer0 one  gid !  drop
    draw>  @gidbmp blit ;

\ for testing purposes, fill the recipes array with a dummy.
\ note that uncommenting this makes all objects disappear
\ :noname
\     #MAXTILES for  ['] noop  recipes push  loop
\ ; execute

map " parallax" objgroup loadobjects
map " game" objgroup loadobjects
map " bounds" objgroup loadobjects

\ ------------------------------------------------------------------------------------------------

200 200 cam 's x 2!
go ok



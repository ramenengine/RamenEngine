empty
$000100 include ramen/brick
$10000 include ramen/tiled/tiled
$000100 include ramen/lib/stage

#1 to #globalscale
stage 1000 pool: layer0

\ ------------------------------------------------------------------------------------------------
\ Load map

" ramen/test/sticker-knight/sandbox.tmx" loadtmx  constant map  constant dom
only forth definitions also xmling also tmxing

map 0 loadbitmaps
map 0 loadrecipes

:noname [ is tmxobj ] ( object-nnn XT -- )  over ?type if cr type then  execute ;
:noname [ is tmxrect ] ( object-nnn w h -- )  .s 3drop ;
:noname [ is tmximage ] ( object-nnn gid -- )
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
: left?  ( -- flag )  <left> kstate  <pad_4> kstate or  ; \ 0 0 joy x -0.25 <= or ;
: right?  ( -- flag ) <right> kstate  <pad_6> kstate or ; \ 0 0 joy x 0.25 >= or ;
: up?  ( -- flag )    <up> kstate  <pad_8> kstate or    ; \ 0 0 joy y -0.25 <= or ;
: down?  ( -- flag )  <down> kstate  <pad_2> kstate or  ; \ 0 0 joy y 0.25 >= or ;

: udlrvec  ( 2vec -- )
  >r
  0 0 r@ 2!
  left? if  -4 r@ x! then
  right? if  4 r@ x! then
  up? if    -4 r@ y! then
  down? if   4 r@ y! then
  r> drop ;

: scroller   layer0 one  me to cam  act>  vx udlrvec ;
scroller  
200 200 cam 's x 2!
go ok



\ SUBJECT and CAM need to be set for scrolling to work.
\ Note that you should put scrolling tilemaps in a different objlist, move them around to offset
\ the global scrolling, and/or replace the renderer or they will scroll too fast and be clipped.

0 value subject
stage object: cam

\ -----------------------------------------------------------------------
[section] camera

: track
    ?dup -exit
    cam 0= if drop exit then
    's x 2@  viewwh  2halve  2-  cam 's x 2! ;

: camtrans
    cam -exit
    m1 al_identity_transform
    m1 cam 's x 2@ 2pfloor  gscale  2negate 2af  al_translate_transform
    m1 al_use_transform ;

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

: flyby   cam as  act>  subject ?exit  vx udlrvec ;

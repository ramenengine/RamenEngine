$000100 [version] stage-ver
\ This is a simple scrolling 2D game framework to use in simple games or as just a way
\ to help you get started more quickly.

\ SUBJECT and CAM need to be set for scrolling to work.
\ Note that you should put scrolling tilemaps in a different objlist, move them around to offset
\ the global scrolling, and/or replace the renderer or they will scroll too fast and be clipped.

defer subject
0 value cam
objlist stage

:is subject 0 ;


\ -----------------------------------------------------------------------
[section] camera

: track
    ?dup -exit
    cam 0= if drop exit then
    's x 2@  viewwh  2halve  2-  cam 's x 2! ;

: camtrans
    cam -exit
    m1 al_identity_transform
    m1  cam 's x 2@ 2pfloor 2negate 2af  al_translate_transform
    m1 #globalscale s>f 1sf dup al_scale_transform
    m1 al_use_transform ;


\ -----------------------------------------------------------------------
[section] go
: think  stage each> behave ;
: physics  stage each>  vx x v+ ;
: playfield  stage each> draw ;
: (go)    go>  noop ;
: (step)  step>  think  stage multi  physics ;
: (show)  show>  black backdrop  subject track  camtrans  playfield ;
: go  (go)  (step)  (show) ;


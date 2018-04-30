$000100 [version] stage-ver
\ This is a simple scrolling 2D game framework to use in simple games or as just a way
\ to help you get started more quickly.

\ PLAYER and CAM need to be set for scrolling to work.
\ Note that you should put scrolling tilemaps in a different objlist, move them around to offset
\ the global scrolling, and/or replace the renderer or they will scroll too fast and be clipped.

0 value player
0 value cam
objlist stage

: ?check  ?dup ?exit  r> drop ;

\ -----------------------------------------------------------------------
[section] camera

: track
    ?dup -exit
    cam ?check
    's x 2@  160 120 2-  cam 's x 2! ;

: camtrans
    cam ?check
    m1 al_identity_transform
    m1 global-scale 1af dup al_scale_transform
    m1  cam 's x 2@ 2pfloor 2negate 2af  al_translate_transform
    m1 al_use_transform ;


\ -----------------------------------------------------------------------
[section] go
: think  stage each> behave ;
: locomote  stage each>  vx x v+ ;
: playfield  stage each> draw ;
: (go)    go>  noop ;
: (step)  step>  think  stage multi  locomote ;
: (show)  show>  black backdrop  player track  camtrans  playfield ;
: go  (go)  (step)  (show) ;


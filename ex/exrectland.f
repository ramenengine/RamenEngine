include kit/ans/section
[section] preamble

empty
$000100 include ramen/brick

objlist stage
stage 100 pool: sprites
stage 2000 pool: boxes

sprites one me value cam
sprites one me value player

2000 4000 4000 cgrid: boxgrid
: extents  0 0 4000 4000 ;
0  bit top#  bit bottom#  bit left#  bit right#  drop

var w  var h  var flags

: *box
    boxes one
    4000 4000 256 256 2- 2rnd x 2!
    256 256 2rnd 5 5 2max w 2!
    x 2@ w 2@  ahb cbox!
    draw>  blue w 2@ rect ;

: *boxes  0 do  *box  ahb boxgrid addcbox  loop ;

\ -----------------------------------------------------------------------
[section] player


also cgriding

  \ push current actor out of given ahb and set appropriate flags
  : ?lr  ( ahb -- )
    [ right# left# or invert ]# flags and!
    vx @ 0> if
      x1 @  ahb x2 @ -  1 +  x +!  right#
    else
      x2 @  ahb x1 @ -  1 -  x +!  left#
    then
    flags or!  0 vx !  ;

  : ?tb  ( ahb - )
    [ bottom# top# or invert ]# flags and!
    vy @ 0> if
      y1 @  ahb y2 @ -  1 +  y +!  bottom#
    else
      y2 @  ahb y1 @ -  1 -  y +!  top#
    then
    flags or!  0 vy !  ;

previous

:noname  nip ?lr  drop false ;
: do-x  ( -- )
  vx @ -exit
  x 2@  vx @ u+  w 2@  ahb cbox!
  ahb ( xt ) literal boxgrid checkcbox
;
:noname  nip ?tb  drop false ;
: do-y  ( -- )
  vy @ -exit
  x 2@  vy @ +  w 2@  ahb cbox!
  ahb ( xt ) literal boxgrid checkcbox
;

\ 4-way input
: left?  ( -- flag )  <left> kstate  <pad_4> kstate or  ; \ 0 0 joy x -0.25 <= or ;
: right?  ( -- flag ) <right> kstate  <pad_6> kstate or ; \ 0 0 joy x 0.25 >= or ;
: up?  ( -- flag )    <up> kstate  <pad_8> kstate or    ; \ 0 0 joy y -0.25 <= or ;
: down?  ( -- flag )  <down> kstate  <pad_2> kstate or  ; \ 0 0 joy y 0.25 >= or ;

: udlrvec  ( 2vec -- )
  >r
  0 0 r@ 2!
  left? if  -2 r@ x! then
  right? if  2 r@ x! then
  up? if    -2 r@ y! then
  down? if   2 r@ y! then
  r> drop ;

: clampvel  x 2@  vx 2@  2+  extents  w 2@ 2-  2clamp  x 2@ 2-  vx 2! ;

: /player
    16 16 w 2!
    160 120 x 2!
    act>  vx udlrvec  clampvel  do-x do-y
    draw>  red w 2@ rectf ;


\ -----------------------------------------------------------------------
[section] camera
create m  16 cells /allot

: camtransform  ( -- matrix )
  m al_identity_transform
  m  cam 's x 2@ 2pfloor 2negate 2af  al_translate_transform
  m al_use_transform ;

: tracked  player 's x 2@  160 120 2-  extents 2clamp  cam 's x 2! ;

\ -----------------------------------------------------------------------

: drawlist  each> draw ;

: (show)
    show>  tracked  black backdrop  camtransform
        boxes drawlist  sprites drawlist ;

: (go)  go>  noop ;
: (step)  step>  sprites each>  act  vx x v+ ;

: go  (go) (step) (show) ;

boxgrid resetcgrid
1000 *boxes
player as /player
go ok
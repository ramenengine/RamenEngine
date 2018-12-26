( variables )
variable lastkeydir

( misc )
: pixalign  at@ 2pfloor at ;
: ztype zcount type ;
: situate  's x 2@ 2+ x 2! ;
: -vel    0 0 vx 2! ;
: left?   <left> kstate ;
: right?  <right> kstate ;
: up?     <up> kstate ;
: down?   <down> kstate ;
: pleft?   <left> pressed ;
: pright?  <right> pressed ;
: pup?     <up> pressed ;
: pdown?   <down> pressed ;
: dirkeys?  left? right? or up? or down? or ;
: rdirkeys?  <left> released  <right> released or  <up> released or  <down> released or ;
: pdirkeys?  <left> pressed <right> pressed or <up> pressed or <down> pressed or ;
: keydir ( -- n )  
    left? if 180 exit then
    right? if 0 exit then
    up? if 270 exit then
    down? if 90 exit then
    -1 ;
: pkeydir ( -- n )  
    pleft? if 180 exit then
    pright? if 0 exit then
    pup? if 270 exit then
    pdown? if 90 exit then
    -1 ;
: !dirkey
    pdirkeys? if pkeydir lastkeydir ! exit then
    rdirkeys? if keydir lastkeydir ! exit then ;
\ also ideing
\ : (debug)
\     get-xy
\         black 0 alpha
\         0 0 at  write-src blend> output @ onto> displayw 4 rows rectf
\         0 0 at-xy .me
\     at-xy ;
\ previous
: (those)  ( objlist filter-xt code - filter-xt code )
    rot each> as over execute if dup >r then ;
: those>  ( objlist filter-xt - <code> )  ( - )  \ note you can't pass anything to <code>
    over 0= if 2drop r> drop ;then
    r> { (those) 2drop } ;


( actors )
objlist tasks
action start ( - )
action idle ( - )
action walk ( - )
action turn ( angle )
var dir \ angle
var (xt) <adr
var target <adr
var clipx  var clipy
var targetid
var attributes <hex
%rect sizeof field ihb  \ interaction hitbox; relative to x,y position
0 0 16 16 defaults 's ihb xywh!

: debug  ( val - val ) dup ['] h. later ;
: live-for  ( n - ) perform> pauses end ;
: ?waste  target @ 's id @ targetid @ <> ?end ;
: *task  me tasks one  dup target ! 's id @ targetid ! act> ?waste ;
: (after)  perform> pauses (xt) @ target @ >{ execute } end ;
: after  ( xt n - ) { *task swap (xt) ! (after) } ;
: after>  ( n - <code> ) r> code> swap after ;
: (every)  perform> begin dup pauses (xt) @ target @ >{ execute } again ;
: every  ( xt n - ) { *task swap (xt) ! (every) } ;
: every>  ( n - <code> ) r> code> swap every ;
: /sprite  draw> pixalign sprite+ ;
: /clipsprite  x 2@ clipx 2!  draw> clipx 2@ cx 2@ 2- 16 16 clip> sprite+ ;
: ipos  x 2@ ihb xy@ 2+ ;
: toward  ( obj - x y )  >{ ipos } ipos 2- angle uvec ;

( grid )
: will-cross-grid? ( - f )
    x @ dup vx @ + 8 8 2/ 2i <>
    y @ dup vy @ + 8 8 2/ 2i <>
    or  
;
: near-grid? ( - f )
    x @ 4 + 8 mod 4 - abs 2 < 
    y @ 4 + 8 mod 4 - abs 2 <  and
;

( actor collisions )
0 value you
: cbox  ( - x y x y )  x 2@ ihb xy@ 2+ ihb wh@ area 1 1 2- ;
: with  ( - ) me to you ;
: hit?  ( bitmask - flag )  \ usage: <subject> as with ... <object> as <bitmask> hit?
    attributes @ and 0= if 0 ;then
    me you = ?exit
    cbox you >{ cbox } overlap? ;
: draw-cbox  cbox 2over 2- 2swap 2pfloor at red 1 1 2+ rect ;
:slang on-top  act> me stage push ;
: show-cboxes  stage one  on-top  draw> stage each> as draw-cbox ;

( actor spawning )
defer spawn  ( - )
: obj-spawn  dir @ stage one dir ! ; 
' obj-spawn is spawn
: from  as ihb xy@ me away ;

\ : map-spawn  <-- how object spawners will "know" a map or room is being loaded.

( actor directional stuff )
var olddir
action evoke-direction  ( - )
: !face  ( - ) dir @ olddir !  evoke-direction ; 
: downward  ( - ) 90 dir ! !face ;
: upward    ( - ) 270 dir !  !face ;
: leftward  ( - ) 180 dir ! !face ;
: rightward ( - ) 0 dir !   !face ;
: ?face     ( - ) dir @ olddir @ = ?exit !face ;    
: dir-anim-table  ( - )
    does> dir @ 90 / cells + @ execute ;

( physics )
var 'physics  \ code
: physics>  r> 'physics ! ;
: ?physics  'physics @ ?dup if >r then ;

( tilemap collision stuff )
create tileprops  s" sample/zelda/data/tileprops.dat" file,
:make tileprops@  >gid dup if 2 - 1i tileprops + c@ then ;
:make on-tilemap-collide  onhitmap @ ?dup if >r then ; 
: /solid   16 16 mbw 2! physics> tilebuf collide-tilemap ;

( event system )
create listeners 100 stack,
create args 100 stack,

: :listen  ( - <code> ; ) ( me=source event c - event c )
    :noname listeners push ; 

: (dispatch)  ( event c xt - event c )
    sp@ >r { execute } r> sp! drop ;

: +args  ( ... #params - )
    dup >r args pushes r> args push ;

: -args  ( - )
    args length args pop - 1 - args truncate ;

: args@  ( - ... )
    args >top dup @ for cell- dup >r @ r> loop drop ;

: occur ( ... #params event c - )
    2>r +args 2r> ['] (dispatch) listeners each 2drop -args ;

: occurred  ( event c event c - event c ... true | event c false )
    2over 2>r compare 0= if 2r> args@ true ;then 2r> 0 ;
    
( curtain open effect )
: *curtain  stage one draw> 128 256 black rectf ;
: curtain-open
    0 64 at *curtain 64 live-for -2 vx !
    128 64 at *curtain 64 live-for 2 vx !
; 

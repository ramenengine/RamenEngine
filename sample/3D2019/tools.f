( variables )
variable lastkeydir
%v3d sizeof field vel

( misc )
: enum  dup constant 1 + ;
: ztype zcount type ;
: situate  's pos 3@ 3+ pos 2! ;
: -vel    0 0 0 vel 3! ;
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
: (those)  ( filter-xt code objlist - filter-xt code )
    each> as over execute if dup >r then ;
: those>  ( filter-xt objlist - <code> )  ( - )  \ note you can't pass anything to <code>
    dup 0= if 2drop r> drop ;then
    r> { swap (those) 2drop } ;
: njump  ( n adr - ) 
    swap cells + @ execute ;
: rndcolor  ( - ) 1 rnd 1 rnd 1 rnd rgb ;    
: bit#  ( bitmask - n )  #1 32 for 2dup and if 2drop i unloop ;then 1 << loop 2drop -1 ;

( tasks )
objlist tasks
var (xt) <xt
var target <adr
var targetid
: debug  ( val - val ) dup ['] h. later ;
: live-for  ( n - ) perform> pauses end ;
: ?waste  target @ 's id @ targetid @ <> ?end ;
: *task  me tasks one  dup target ! 's id @ targetid ! act> ?waste ;
: (after)  perform> pauses (xt) @ target @ >{ execute } end ;
: after  ( xt n - ) { *task swap (xt) ! (after) } ;
: after>  ( n - <code> ) r> code> swap after ;
: (every)  perform> begin (xt) @ target @ >{ execute } dup pauses again ;
: every  ( xt n - ) { *task swap (xt) ! (every) } ;
: every>  ( n - <code> ) r> code> swap every ;

( cuboid struct )
struct %cuboid
    %cuboid %rect sizeof sfield cuboid>rect
    %cuboid svar cuboid.z
    %cuboid svar cuboid.d

: cz@    cuboid.z @ ;              : cz!    cuboid.z ! ;
: d@    cuboid.d @ ;              : d!    cuboid.d ! ;
: cz2@    dup cz@ swap d@ + ;
: cz2!    dup cz@ rot - swap d! ;
: xyz@   dup xy@ rot cz@ ;
: xyz!   dup >r cz! r> xy! ;
: whd@   dup wh@ rot d@  ;
: whd!   dup >r d! r> wh! ;
: xyzwhd@  dup >r xyz@ r> whd@ ;
: xyzwhd!  dup >r whd! r> xyz! ;
: xyz2@   dup xy2@ rot cz2@ ;
: xyz2!   dup >r cz2! r> xy! ;

( 3D actors )
extend-class _role
    action start ( - )
    action idle ( - )
    action walk ( - )
    action turn ( angle )
end-class

extend-class _actor
    var dir \ angle
    var clipx  var clipy
    var flags <hex
    3 cells field startpos
    %cuboid sizeof field ihb  \ interaction hitbox; relative to position
end-class

0 0 0 16 16 16 _actor template 's ihb xyzwhd!

\ : ipos     pos 3@ ihb xyz@ 3+ ;
\ : toward   ( obj - x y )  >{ ipos } ipos 2- angle uvec ;
: !startpos pos 3@ startpos 3! ;


( 3D actor collisions )
0 value you

: ibox  ( - x y x y )  pos 2@ ihb xy@ 2+ ihb wh@ aabb ;
: ibreadth  ( - z z )  pos z@ ihb cz@ + ihb d@ over + ;
: cross?  ( lo hi lo hi - flag )  rot >= >r swap <= r> or ;
: with  ( - ) me to you ;
: hit?  ( attributes - flag )  \ usage: <subject> as with ... <object> as <bitmask> hit?
    flags @ and 0= if 0 ;then
    me you = if 0 ;then
    ibreadth you >{ ibreadth } cross? dup -exit drop
    ibox you >{ ibox } overlap? ;

\ : draw-ibox  cbox 2over 2- 2swap 2pfloor at red 1 1 2+ rect ;
: on-top  act> me stage push ;
\ : show-iboxes  stage one  on-top  draw> stage each> as draw-ibox ;

( actor spawning )
stage value spawner
\ defer spawn
: 3away  ( x y z obj - )  's pos 3@ 3+ at3 ;
: from  dup 's ihb xyz@ rot 3away ;
: spawn  me to spawner me from ;
\ : map-spawn  <-- how object spawners will "know" a map or room is being loaded.

( physics )
var 'physics  \ code
: physics>  r> 'physics ! ;
: ?physics  'physics @ ?dup if >r then ;


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
    
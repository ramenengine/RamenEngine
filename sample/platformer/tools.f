depend sample/platformer/lib/tilemap2.f

( misc )
: enum  dup constant 1 + ;
: ztype zcount type ;
: live-for  ( n - ) perform> pauses end ;
: (those)  ( filter-xt code objlist - filter-xt code )
    each> as over execute if dup >r then ;
: those>  ( filter-xt objlist - <code> )  ( - )  \ note you can't pass anything to <code>
    r> me { swap (those) 2drop } ;
: njump  ( n adr - ) 
    swap cells + @ execute ;
: rndcolor  ( - ) 1 rnd 1 rnd 1 rnd rgb ;    
: bit#  ( bitmask - n )
    #1 32 for 2dup and if 2drop i unloop ;then 1 << loop 2drop -1 ;
: sf@+  dup sf@ cell+ ;
: tinted   fore sf@+ f>p swap sf@+ f>p swap sf@+ f>p swap sf@+ f>p nip tint 4! ;
: /sprite  draw> sprite ;
: *sprite   ( image ) stage one tinted img ! /sprite ;
: csprite  img @ imagewh 0.5 0.5 2* cx 2!  sprite ;
: *csprite  ( image ) stage one tinted img ! draw> csprite ;
: >data  project count s" data/" strjoin 2swap strjoin ;  \ prepend assets with data path
: hide  's hidden on ;
: reveal  's hidden off ;
: dynamic?  dyn @ 0<> ;
: static?   dyn @ 0= ;

( directional key tools )
variable lastkeydir
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

( tasks )
objlist: tasks

extend: _actor
    var (xt) <word
    var target <adr
    var targetid 
;class

: ?waste  target @ { ?id } ?dup if @ targetid @ <> ?end then ;
: target!   dup target ! { ?id } ?dup if @ targetid ! then ;
: *task  me tasks one  target!  act> ?waste ;
: (after)  perform> pauses (xt) @ target @ { execute } end ;
: after  ( xt n - ) me { *task swap (xt) ! (after) } ;
: after>  ( n - <code> ) r> code> swap after ;
: (every)  perform> begin (xt) @ target @ { execute } dup pauses again ;
: every  ( xt n - ) me { *task swap (xt) ! (every) } ;
: every>  ( n - <code> ) r> code> swap every ;

( physics )
_actor fields:   var 'physics <adr \ code
: physics>  r> 'physics ! ;
: ?physics  'physics @ ?dup if >r then ;

( tilemap collision )
_actor fields:  var onmaphit <word \ xt
:make tileprops@  $3ff000 and 1.0 and 0<> ;
:make on-tilemap-collide  onmaphit @ execute ; 

( extend loop )
: think  ( - ) stage acts  tasks multi  stage multi  tasks acts ;
: physics ( - ) stage each> as ?physics vx 2@ x 2+! ;
: tools:step ( - ) step> think physics sweep ;
tools:step

( canned movements )
: control-8way  
    act>
    0 
    <left> kstate if drop -1 then
    <right> kstate if drop 1 then
    0
    <up> kstate if drop -1 then
    <down> kstate if drop 1 then
    vx 2!
;

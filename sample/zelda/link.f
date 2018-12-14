( Data )
16 16 s" link-tiles-sheet.png" >data tileset: link.ts

0 link.ts 1 6 / anim: link-anim-walku 2 , 2 h, ;anim
0 link.ts 1 6 / anim: link-anim-walkd 0 , 1 , ;anim
0 link.ts 1 6 / anim: link-anim-walkl 3 h, 4 h, ;anim
0 link.ts 1 6 / anim: link-anim-walkr 3 , 4 , ;anim

create link-walk-anims
    ' link-anim-walkr ,
    ' link-anim-walku ,
    ' link-anim-walkl ,
    ' link-anim-walkd ,

( Logic )
defrole link-role
var olddir
\ rolevar walkanims
var spd  
var ctr
action idle
action walk  
action start
        
\ todo: make the animation part dynamic, make this code reusable...
: !face  dir @ olddir !  dir @ 90 / cells link-walk-anims + @ execute ; 
: downward  270 dir ! !face ;
: upward    90 dir !  !face ;
: leftward  180 dir ! !face ;
: rightward 0 dir !   !face ;
: ?face  dir @ olddir @ = ?exit !face ;    
: !walkv  dir @ spd @ vec vx 2! ;
: snap
    x @ 4 + dup 8 mod - x !
    y @ 4 + dup 8 mod - y !
;
: turn    lastkeydir @ dir ! !walkv ?face ;
: ?180    pkeydir dir @ - abs 180 = if turn then ;
: ?walk   dirkeys? -exit  ?180 walk ;
: ?stop   dirkeys? ?exit  idle ; 
: ?edge ; 
: ?turn
    dirkeys? -exit lastkeydir @ dir @ = ?exit
    near-grid? if snap turn ;then
;

link-role :to walk
    0.15 anmspd !
        0 perform> !walkv begin ?stop ?edge ?180 ?turn pause again ;
link-role :to idle
    -vel 0 anmspd !
    0 perform> begin ?walk pause again ;
link-role :to start  -9999 olddir ! downward idle  act> !dirkey ;

: /link  link as  link.ts img ! /sprite  link-role role !  1.25 spd !  start ;
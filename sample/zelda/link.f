( Data )
16 16 s" link-tiles-sheet.png" >data tileset: link.ts

0 link.ts 1 6 / autoanim: link-anim-walku 2 , 2 h, ;anim
0 link.ts 1 6 / autoanim: link-anim-walkd 0 , 1 , ;anim
0 link.ts 1 6 / autoanim: link-anim-walkl 3 h, 4 h, ;anim
0 link.ts 1 6 / autoanim: link-anim-walkr 3 , 4 , ;anim

create link-walk-anims
    ' link-anim-walkr ,
    ' link-anim-walku ,
    ' link-anim-walkl ,
    ' link-anim-walkd ,

( Logic )
defrole link-role
var olddir
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
: ?face   dir @ olddir @ = ?exit !face ;    
: !walkv  dir @ spd @ vec vx 2! ;
: snap    x 2@ 4 4 2+ 2dup 8 8 2mod 2- x 2! ;
: turn    lastkeydir @ dir ! !walkv ?face ;
: ?180    pkeydir dir @ - abs 180 = if turn then ;
: ?walk   dirkeys? -exit  ?180 walk ;
: ?stop   dirkeys? ?exit  idle ; 
: ?edge
    x 2@  0 64 8 + 256 236 16 8 2- inside? ?exit
    0 s" player-left-room-event" occur
;

: ?turn
    dirkeys? -exit lastkeydir @ dir @ = ?exit
    near-grid? if snap turn ;then
;

link-role :to walk ( - )
    0.15 anmspd !  !walkv ?edge ?turn
    0 perform> begin ?stop ?edge ?180 pause ?turn again ;
link-role :to idle ( - )
    -vel 0 anmspd !
    0 perform> begin ?walk pause again ;
link-role :to start ( - )
    1.25 spd !  -9999 olddir ! downward idle  act> !dirkey ;

: /link
    link as  link.ts img !  /solid /sprite  link-role role !
    16 8 mbw 2!  0 8 cx 2! start ;
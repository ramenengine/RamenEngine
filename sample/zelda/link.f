( Data )
16 16 s" link-tiles-sheet.png" >data tileset: link.ts

0 link.ts 1 6 / autoanim: anim-link-walku 2 , 2 h, ;anim
0 link.ts 1 6 / autoanim: anim-link-walkd 0 , 1 , ;anim
0 link.ts 1 6 / autoanim: anim-link-walkl 3 h, 4 h, ;anim
0 link.ts 1 6 / autoanim: anim-link-walkr 3 , 4 , ;anim

create evoke-link-walk dir-anim-table 
    ' anim-link-walkr ,
    ' anim-link-walku ,
    ' anim-link-walkl ,
    ' anim-link-walkd ,

0 link.ts 0 autoanim: anim-link-swingu 10 , ;anim
0 link.ts 0 autoanim: anim-link-swingd 9 , ;anim
0 link.ts 0 autoanim: anim-link-swingl 11 h, ;anim
0 link.ts 0 autoanim: anim-link-swingr 11 , ;anim

create evoke-link-swing dir-anim-table 
    ' anim-link-swingr ,
    ' anim-link-swingu ,
    ' anim-link-swingl ,
    ' anim-link-swingd ,


( Logic )
defrole link-role
var olddir
var spd  
var ctr
action idle
action walk  
action start
action attack
        
\ todo: make the animation part dynamic, make this code reusable... 
: !face  dir @ olddir !  evoke-link-walk ; 
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
    0 s" player-left-room" occur
;
: ?turn
    dirkeys? -exit lastkeydir @ dir @ = ?exit
    near-grid? if snap turn ;then
;
: ?attack
    <z> pressed -exit
    -vel
    evoke-link-swing
    0 s" player-swung-sword" occur
    13 pauses
    idle
;


link-role :to walk ( - )
    0.15 anmspd !  !walkv ?edge ?turn
    0 perform> begin ?attack ?stop ?edge ?180 pause ?turn again ;
link-role :to idle ( - )
    !face -vel 0 anmspd ! ?walk 
    0 perform> begin ?attack ?walk pause again ;
link-role :to start ( - )
    1.25 spd !  -9999 olddir ! downward idle  act> !dirkey ;

: /link
    link as  link.ts img !  /solid /sprite  link-role role !
    16 8 mbw 2!  0 8 cx 2! start ;
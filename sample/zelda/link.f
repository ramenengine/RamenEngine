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
var trigged
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
    x 2@  -1 63 8 + 257 237 16 8 2- inside? ?exit
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

( cave stuff )
: emerge
    snap  downward  trigged on  -act  halt
    /clipsprite  16 y +!  0 -0.25 vx 2!
    ['] start 64 after 
;
: descend
    x 2@ tempx 2!  
    snap  upward  -act halt /clipsprite  0 0.25 vx 2!
    ['] start 64 after
;
    
: ?trig
    x 2@ vx 2@ 2+ 2 -6 2+ 16 16 2mod 4 <= swap 4 <= and if
        x 2@ vx 2@ 2+ 2 -6 2+ 16 16 2/ roombuf loc @ >gid 2 - >r
        r@ 0 =
        r@ 6 = or
        r@ 12 = or
        r@ 22 = or
        r@ 28 = or
        r> 34 = or if
            trigged @ ?exit
            trigged on
            descend
            ['] cave 64 after
        else
            trigged off
        ;then
    then
;

link-role :to walk ( - )
    0.15 anmspd !  !walkv ?edge ?turn
    0 perform> begin ?attack ?stop ?edge ?180 pause ?turn again ;
link-role :to idle ( - )
    !face -vel 0 anmspd ! ?walk 
    0 perform> begin ?attack ?walk pause again ;
link-role :to start ( - )
    /sprite  hidden off  snap  1.3 spd !  -9999 olddir !  downward idle
    act> !dirkey ?trig ;

: /link
    link as  link.ts img !  /solid  link-role role !
    16 8 mbw 2!  0 8 cx 2!  start ;

-8 link 's ihb y!

:listen
    s" player-entered-cave" occurred if
        link >{
            ( x y ) x 2!
            upward idle
        }
    ;then
    s" player-exited-cave" occurred if
        link >{
            tempx 2@ x 2!
            emerge
        }
    ;then
;
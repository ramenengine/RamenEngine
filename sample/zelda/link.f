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
action idle
action walk  
action start

: walk_snap  8 spd @ / ;
: ?face
    dir @ olddir @ = ?exit
    dir @ olddir !  dir @ 90 / cells link-walk-anims + @ execute ;
: !walkv   dir @ spd @ vec vx 2! ;
: ?walk    dirkeys? -exit  walk ;
: ?turnstop  dirkeys? 0= if  idle  exit then  ?face !walkv ;
: ?udlr4  dirkeysup? if  !dir  else  !pdir  then  ;
: nearest  dup >r  2 / + dup  r> mod - ;
: csnap  dup @ 8 nearest swap ! ;
: snap  x csnap y csnap ;
: 1pace  walk_snap for  pause  ?udlr4  loop  snap ;

link-role :to walk
    0.15 anmspd !  !walkv  ?face
    0 perform>  begin  ?edge  1pace  ?turnstop  again ;
link-role :to idle   -vel ?face 0 anmspd ! 0 perform> begin !dir ?walk pause again ;
link-role :to start  -9999 olddir !  270 dir !  idle ;

: /link  link as  link.ts img ! /sprite  link-role role !  1.5 spd !  start ;
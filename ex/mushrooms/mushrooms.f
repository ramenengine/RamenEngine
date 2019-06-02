( ---=== Attack of the Cheeselords ===--- )
include ramen/ramen.f
project: ex/mushrooms
empty
depend ramen/basic.f
depend ramen/lib/std/tilecol.f
depend ramen/lib/std/zsort.f
320 240 resolution
ld gfx

: strings:  ( - <name> ) ( n - adr )
    create does> swap for count + loop ;

: vectors:  ( - <name> ) ( n - adr )
    create does> swap vectors + ;

( data )
16 16 s" mushroom-bg.png" >datapath tileset: mushroom-bg.png

strings: level[]
    ," test.map" \ 0
    ," 1-1.map"  \ 1
    ," test.map" \ 2
    ," test.map" \ 3
    ," test.map" \ 4
    ," test.map" \ 5

vectors: fence[]
    128 , 128 , \ 0
    128 , 128 , \ 1
    128 , 128 , \ 2
    128 , 128 , \ 3
    128 , 128 , \ 4
    128 , 128 , \ 5   

create tileprops hex
    00 , 00 , 00 , 00 , 00 , FF , FF , 00 , FF , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 
    00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , FF , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 
    00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 
    00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 00 , 
fixed
:make tileprops@  dup -exit  1 - cells tileprops + @ ;

( variables )
stage actor: p1
0 value level#
create level$ 256 /allot
_actor fields:
    var flags

: checker   bit does> @ flags @ and 0<> ;
: flag  dup constant checker ;  
#1
    flag solid# solid?
drop

( myconid states )
0
    enum roaming#
    enum enlisted#
    enum captured#
    enum transiting#
    enum saved#
drop

( myconid jobs )
0
    enum worker#
    enum engineer#
drop


( roles )
role: [myconid]
role: [cheeselord]

( map tools )
: pepper  swap for  dup fence 2@ 2rnd tilebuf loc !  loop drop ;
: grasses  5 pepper ;
: flowers  21 pepper ;

( plants )
16 16 s" mushroom-plants.png" >datapath tileset: mushroom-plants.png

\ define self-playing animation. AUTOANIM: ( image speed - <name> )
mushroom-plants.png 1 8 / autoanim: /grass.anim 0 , 1 , 2 , 1 , ;anim
mushroom-plants.png 1 8 / autoanim: /flower.anim 3 , 4 , 5 , 4 , ;anim

: /culled  draw> sprite ;
: /grass  /culled /grass.anim ;
: /flower  /culled /flower.anim ;

( collision detection )
: /solid  solid# flags or!  -4 0 mbx 2!  10 8 mbw 2!  ;
: ?tilecol
    solid? if
        tilebuf tilemap-physics
    then
    vx 2@ x 2+!
;

( myconids )
16 16 s" myconids.png" >datapath tileset: myconids.png
_actor fields:
    var leader
    var state
    var job
1 32 / constant walk-anim-speed
myconids.png walk-anim-speed autoanim: /myconid1.anim 2 , 3 , 4 , 3 , ;anim
myconids.png walk-anim-speed autoanim: /myconid2.anim 6 , 7 , 8 , 7 , ;anim
myconids.png walk-anim-speed autoanim: /engineer.anim 11 , 12 , 13 , 12 , ;anim

: /myconid1  /shadowed /myconid1.anim ;
: /myconid2  /shadowed /myconid2.anim ;
: -v  0 0 vx 2! ;
: rdelay  0.5 2 between delay ;
: dist  's x x proximity ;
: close?  leader @ dist 40 < ;
: /wander  0 perform> begin
    leader @ if
        close? if
            360 rnd 0.5 vec vx 2! rdelay -v rdelay 
        else
            pause
        then
    else
        -v rdelay 360 rnd 0.5 vec vx 2! rdelay 
    then
    again ;
: chase   leader @ 's x x vdif angle 1.5 vec vx 2! ;
: enlist  p1 leader !  enlisted# state !  /wander act> close? not if chase /wander then ;
: /?enlist  act> p1 dist 32 <= if cr ." Join!" enlist then ;
\ : /myconid  #2 rnd if /myconid1 else /myconid2 then /wander ;
: /myconid  [myconid] role !  /myconid2 /solid /wander /?enlist ;
: /engineer [myconid] role !  engineer# job !  /solid /wander /?enlist
    /engineer.anim   draw>  !org  1 1 shadow sprite     9 nsprite ;
: myconids  for  playfield-box somewhere at  one /myconid  loop ; 
: /avatar   [myconid] role !  1.333 /vpan  /solid ;


( houses - tiles 37, 38 )
: /house1   mushroom-bg.png img !  draw> 0 -30 +at  0 0 32 48 0 bsprite ;
: /house2   mushroom-bg.png img !  draw> 0 -30 +at  32 0 32 48 0 bsprite ;


( cheeselord )
96 128 s" cheeselord.png" >datapath tileset: cheeselord.png
cheeselord.png walk-anim-speed autoanim: /cheeselord.anim 0 , 1 , ;anim
: /cheeselord  [cheeselord] role !  /cheeselord.anim /wander draw> 4 4 shadow sprite ;


( hud )
: #myconids ( - n )
    0 stage each> 's role @ [myconid] = if 1 + then ;
: #roaming ( - n )
    0 stage each> { role @ [myconid] =  state @ roaming# =  and if 1 + then } ;
: #enlisted ( - n )
    0 stage each> { role @ [myconid] =  state @ enlisted# =  and if 1 + then } ;
: #engineers ( - n )
    0 stage each> { role @ [myconid] =  job @ engineer# =  and if 1 + then } ;

: /hud
    draw>
        default-font font>
        s" Roaming: " print 100 0 +at
        #roaming 1i (.) print 50 0 +at
        s" Enlisted: " print 100 0 +at
        #enlisted 1i (.) print 50 0 +at
        s" Engineers: " print -200 40 +at
        #engineers 1i (.) print 
;

 

( load map )
: thinout  each> { dyn @ if me dismiss then } ;
: cleanup  stage thinout sweep ;
: >grass   8 swap ! ;
: ?object  ( tileadr - )
            dup @ 5 = if  >grass  one /grass ;then
            dup @ 21 = if >grass  one /flower ;then
            dup @ 22 = if >grass  at@ p1 's x 2! ;then
            dup @ 23 = if >grass  one /engineer ;then
            dup @ 37 = if >grass  one /house1 ;then
            dup @ 38 = if >grass  one /house2 ;then
            dup @ 39 = if >grass  one /myconid ;then
            drop
;
: gussy
    128 for
        128 for
            i j 16 16 2* at  
            i j tilebuf loc ?object     ( pass the tile's address to ?OBJECT (replaces some tiles with sprites)
        loop
    loop
;
: reload
    cleanup  \ clean up the stage of any and all sprites we've added
    mushroom-bg.png to bank
    level$ count >datapath 0 tilebuf [] tilebuf length cells @file  \ grab that tilemap
;
: level ( n - )
    to level#
    level# level[] count level$ place
    level# fence[] fence vector move
    reload
    gussy \ replace certain tiles with objects
;


( setup the stage. )
/gfx 
bg as /bg
cam as p1 /follow 
p1 as /myconid1 /avatar
32 32 at one /hud me hud push

\ replace the stepper; collisions etc
: think  stage acts stage multi ;
: contain  x 2@ playfield-clamp x 2! ;
: physics  stage each> as  ?tilecol  contain ;
: ?edit  [defined] dev [if] <f12> pressed if s" ld edit" evaluate wipe then [then] ;
: mushrooms/step  step> think physics sweep ?edit ; 
mushrooms/step


0 level

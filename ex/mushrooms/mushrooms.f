( ---=== Land of the Cheeselords ===--- )
include ramen/ramen.f
empty
depend ramen/basic.f
depend ramen/lib/std/tilecol.f
depend ramen/lib/std/zsort.f
project: ex/mushrooms
320 240 resolution
ld gfx

( assets )
16 16 s" mushroom-bg.png" >datapath tileset: mushroom-bg.png

( myconid fields )
_actor fields:
    var leader

( variables )
stage actor: p1

( roles )
role: [myconid]
role: [cheeselord]

( map tools )
: savemap  ( - )
    0 0 tilebuf loc
        tilebuf length cells
        s" stage.tilemap" >datapath
        file! ;
: clearmap  0 0 tilebuf loc tilebuf length 8 ifill ;
: pepper  swap for  dup 128 128 2rnd tilebuf loc !  loop drop ;
: grasses  5 pepper ;
: flowers  21 pepper ;

16 16 s" mushroom-plants.png" >datapath tileset: mushroom-plants.png

( grass )
\ define self-playing animation.
\ AUTOANIM: ( image speed - <name> )
mushroom-plants.png  1 8 /  autoanim: /grass.anim 0 , 1 , 2 , 1 , ;anim
: /culled  draw> sprite ;
: /grass  /culled /grass.anim ;

( flower )
mushroom-plants.png 1 8 / autoanim: /flower.anim 3 , 4 , 5 , 4 , ;anim
: /flower  /culled /flower.anim ;

( myconids )
16 16 s" myconids.png" >datapath tileset: myconids.png
1 32 / constant walk-anim-speed
myconids.png walk-anim-speed autoanim: /myconid1.anim 1 , 1 ,h ;anim
myconids.png walk-anim-speed autoanim: /myconid2.anim 2 , 2 ,h ;anim
: -at  2negate +at ;
: shadow     2>r tint 4@ 0 0 0 1 tint 4! 2r@ +at sprite 2r> -at tint 4! ;
: /shadowed  draw> 1 1 shadow sprite ;
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
: chase   leader @ 's x 2@ x 2@ 2- angle 1.5 vec vx 2! ;
: enlist  p1 leader ! /wander act> close? not if chase /wander then ;
: /?enlist  act> p1 dist 32 <= if cr ." Enlist!" enlist then ;
\ : /myconid  #2 rnd if /myconid1 else /myconid2 then /wander ;
: /myconid  [myconid] role !  /myconid2 /wander /?enlist ;
: myconids  for  playfield-box somewhere at  one /myconid  loop ; 
: /avatar   [myconid] role !  1.333 /pan ;


( houses - tiles 37, 38 )
: /house1   mushroom-bg.png img !  draw> 0 -30 +at  0 0 32 48 0 bsprite ;
: /house2   mushroom-bg.png img !  draw> 0 -30 +at  32 0 32 48 0 bsprite ;


( cheeselord )
96 128 s" cheeselord.png" >datapath tileset: cheeselord.png
cheeselord.png walk-anim-speed autoanim: /cheeselord.anim 0 , 1 , ;anim
: /cheeselord  [cheeselord] role !  /cheeselord.anim /wander draw> 4 4 shadow sprite ;


( load map )
: thinout  each> { dyn @ if me dismiss then } ;
: cleanup  stage thinout sweep ;
: ?object  ( tileadr - )
            dup @ 5 = if 8 swap !  one /grass ;then
            dup @ 21 = if 8 swap !  one /flower ;then
            dup @ 37 = if 8 swap !  one /house1 ;then
            dup @ 38 = if 8 swap !  one /house2 ;then
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
    s" stage.tilemap" >datapath 0 tilebuf [] tilebuf length cells @file  \ grab that tilemap
    /gfx
;
: loadmap
    reload
    gussy \ replace certain tiles with objects
;


( setup the stage. )
bg as /bg
cam as p1 /follow viewwh w 2!
p1 as /myconid1 /avatar


\ replace the stepper; collisions etc
: think  stage acts stage multi ;
: contain  x 2@ playfield-clamp x 2! ;
: physics  stage each> as vx 2@ x 2+!  contain ;
: mushrooms/step  step> think physics sweep ;
mushrooms/step

loadmap

500 myconids
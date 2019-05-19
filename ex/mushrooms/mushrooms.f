( ---=== Land of the Cheeselords ===--- )
include ramen/ramen.f
empty
depend ramen/basic.f
depend ramen/lib/std/tilecol.f
depend ramen/lib/std/zsort.f
project: ex/mushrooms
320 240 resolution

( tilemap fields )
_actor fields:
    var scrollx var scrolly
    var w var h

( variables )
128 128 * array: tilebuf
:make loc  ( col row array2d - adr )  >r 2pfloor 128 * + r> [] ;
stage actor: bg 
stage actor: p1
stage actor: cam
: playfield-box  0 0  128 16 * dup ;
: mydims  img @ if spritewh else w 2@ then ;
: playfield-clamp  playfield-box 2>r 2max 2r> mydims 2- 2min ;

( visibility culling )
: sprite  ( - )
    x 2@ spritewh aabb cam 's x 2@ viewwh aabb overlap? if sprite ;then ;

( camera )
: update-camera
    cam as
    x 2@ playfield-clamp x 2!   \ keep in playfield (otherwise things glitch visually)
    x 2@ bg 's scrollx 2!    \ copy position to bg scroll
    x 2@ bg 's x 2!   \ move the bg in step with the camera to counteract view transform
;

: /follow  ( actor - )
    perform>  begin  dup { x 2@ spritewh 2 2 2/ 2+ } viewwh 2 2 2/ 2- x 2!  pause again ;

( draw tiles )
0 value bank  \ image
: ?skip  dup ?exit  drop  r> drop ;
: tile  ?skip 1 - >r bank >bmp r> bank subxywh 0 bblit ;
: tile+  tile 16 0 +at ;

( load tileset )
16 16 s" mushroom-bg.png" >datapath tileset: mushroom-bg.png
mushroom-bg.png to bank

( tilemap renderer )
: scrolled  ( - col row )
    scrollx 2@ playfield-clamp scrollx 2!
    scrollx 2@ 2pfloor 16 16 2mod 2negate +at
    scrollx 2@ 2pfloor 16 16 2/ 2pfloor ;
    
: tilemap  ( col row - )
    tilebuf loc
    hold>
    viewh 16 / pfloor 1 + for
        dup  at@ 2>r
        vieww 16 / pfloor 1 + for
            dup @ tile+
            cell+ 
        loop
        drop 128 cells +
        2r> 0 16 2+ at 
    loop  drop ;

: /bg  draw> scrolled tilemap ;


( generate world )
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
: /wander  0 perform> begin -v rdelay 360 rnd 0.5 vec vx 2! rdelay again ;
: dist  's x x proximity ;
: enlist  act> p1 dist 40 <= ?exit  p1 's x 2@ x 2@ 2- angle 1.5 vec vx 2! ;
: /?enlist  act> p1 dist 64 <= if cr ." Enlist!" enlist then ;
\ : /myconid  #2 rnd if /myconid1 else /myconid2 then /wander ;
: /myconid  /myconid2 /wander /?enlist ;
: myconids  for  playfield-box somewhere at  one /myconid  loop ; 
: /avatar  1.333 /pan ;


( houses - tiles 37, 38 )
: /house1   mushroom-bg.png img !  draw> 0 0 32 48 0 bsprite ;
: /house2   mushroom-bg.png img !  draw> 32 0 32 48 0 bsprite ;


( cheeselord )
96 128 s" cheeselord.png" >datapath tileset: cheeselord.png
cheeselord.png walk-anim-speed autoanim: /cheeselord.anim 0 , 1 , ;anim
: /cheeselord  /cheeselord.anim /wander draw> 4 4 shadow sprite ;


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
    s" stage.tilemap" >datapath 0 tilebuf [] tilebuf length cells @file  \ grab that tilemap
;
: loadmap
    reload
    gussy \ replace certain tiles with objects
;


( map editing tools )
: savemap  ( - )
    0 0 tilebuf loc
        tilebuf length cells
        s" stage.tilemap" >datapath
        file! ;


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


\ replace the renderer; apply view transform at camera's pov
: y!z  stage each> as  y @ spriteh + zorder ! ;
: !forcez  bg as  0 zorder ! ;
: playfield  cam as view> y!z !forcez hold> stage draws ;
:now  show> ramenbg mount update-camera playfield ;

loadmap

500 myconids
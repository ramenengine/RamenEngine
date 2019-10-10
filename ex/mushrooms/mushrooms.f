( ---=== Attack of the Cheeselords ===--- )
include ramen/ramen.f
project: ex/mushrooms
empty
depend ramen/basic.f
depend ramen/lib/std/tilecol.f
depend ramen/lib/std/zsort.f
320 240 resolution
ld gfx
ld tunnel

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
    60 , 45 ,   \ 1
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

100 stack: party


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
role: [goal]

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

( "net" )
_actor fields:
    var radius
    var net    \ allows actors to have associated nets
: /circlef  draw>  tint 4@ rgba radius @ circlef ;
: /net  1 0 0 0.5 tint 4!  /circlef ;
: grow ( amount )  6 / for 6 radius +! pause loop ;
: a  tint color.a ;
: fadeout ( spd )  negate begin pause dup a +! a @ 0 <= until drop 0 a ! ;
\ : /glued ( net - )  net ! act> x 2@ vx 2@ net @ { vx 2! x 2! } ;

( myconids )
ld myconids


( houses - tiles 37, 38 )
: /house1
    [goal] role !  mushroom-bg.png img !
    act>
        engineer# in-party if
            p1 dist 20 <= if
                <d> pressed if
                    cr ." Digigigigg"
                then
            then
        then
    draw>
        -16 -36 +at  0 0 32 48 0 bsprite 
        engineer# in-party if
            p1 dist 20 <= if
                x 2@ 8 -20 2+ at dig.png >bmp blit  \ dig icon
            then
        then
;
\ : /house2   /house draw> -16 -36 +at  32 0 32 48 0 bsprite ;


( cheeselord )
96 128 s" cheeselord.png" >datapath tileset: cheeselord.png
cheeselord.png walk-anim-speed autoanim: /cheeselord.anim 0 , 1 , ;anim
: /cheeselord  [cheeselord] role !  /cheeselord.anim /wander draw> 4 4 shadow sprite ;


( hud )
: is?  role @ = ;
: count>  r> locals| f |  0 swap each> f call if 1 + then ;
: #myconids ( - n )
    stage count> { [myconid] is? } ;
: #roaming ( - n )
    stage count> { [myconid] is?  state @ roaming# =  and } ;
: #enlisted ( - n )
    party length ;
: #engineers ( - n )
    stage count> { [myconid] is?  job @ engineer# =  and } ;
: hudtext
    default-font font>
        s" Roaming=" print 100 0 +at
        #roaming 1i (.) print 50 0 +at
        s" Party=" print 100 0 +at
        #enlisted 1i (.) print -250 8 +at
        s" Engineers=" print 100 0 +at
        #engineers 1i (.) print 
;
: /hud
    draw> at@ 1 1 +at black hudtext at white hudtext
;

 

( loading levels )
: thinout  each> { dyn @ if me dismiss then } ;
: cleanup  stage thinout sweep ;
: >grass   8 swap ! ;
: ?object  ( tileadr - )
            dup @ 5 = if  >grass  one /grass ;then
            dup @ 21 = if >grass  one /flower ;then
            dup @ 22 = if >grass  at@ p1 's x 2! ;then
            dup @ 23 = if >grass  one /engineer ;then
            dup @ 37 = if >grass  one /house1 ;then
            \ dup @ 38 = if >grass  one /house2 ;then
            dup @ 39 = if >grass  one /myconid ;then
            drop
;
: gussy
    fence y@ for
        fence x@ for
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


( misc )
: myconids  for  playfield-box somewhere at  one /myconid  loop ; 


( setup the stage. )
/gfx 
bg as /bg
cam as p1 /follow 
p1 as /myconid1 /avatar
0 viewh 16 - at one /hud me hud push

\ replace the stepper; collisions etc
: think  stage acts stage multi ;
: contain  x 2@ playfield-clamp x 2! ;
: physics  stage each> as  ?tilecol  contain ;
: ?edit  [defined] dev [if] <f12> pressed if s" ld edit" evaluate wipe then [then] ;
: mushrooms/step  step> think physics sweep ?edit ; 
mushrooms/step

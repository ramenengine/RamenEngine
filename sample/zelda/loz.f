empty
include ramen/stdpack.f       
256 236 resolution
include sample/zelda/ui.f

: >data  s" sample/zelda/data/" 2swap strjoin ;

( misc )
depend afkit/ans/param-enclosures.f
depend sample/tools.f
depend sample/events.f
depend ramen/lib/upscale.f

( "engine" )
include sample/zelda/tools.f
include sample/zelda/common.f

( game specific stuff )
include sample/zelda/globals.f
include sample/zelda/map.f

( flags ) nr
nextflag
    bit #weapon
    bit #inair
    \ bit #entrance
    \ bit #ground
    \ bit #fire
    \ bit #water
    bit #npc
    bit #item
    bit #enemy
drop

( rolefields )
extend: _role
    8 cells field dropables
;class

( actions ) nr
action start ( - )
action idle ( - )
action walk ( - )
action turn ( angle )

( vars ) nr
extend: _actor 
    var hp
    var maxhp
    var atk
    var hp  
    var maxhp
    var dir \ angle
    var flags <hex
;class
_actor prototype as
    2 hp !
    2 maxhp !

( misc )
: damage  ( n - )
    damaged @ if drop ;then
    dup negate hp +! damaged !
    hp @ 0 <= if die ;then
    60 after> damaged off ;
: in-playfield? ( - flag ) x 2@  -1 63 8 +  257 248  16 8 2- inside? ;
: will-cross-grid? ( - f )
    x @ dup vx @ + 8 8 2/ 2i <>
    y @ dup vy @ + 8 8 2/ 2i <>
    or  
;
: near-grid? ( - f )
    x @ 4 + 8 mod 4 - abs 2 < 
    y @ 4 + 8 mod 4 - abs 2 <  and
;

( tilemap collision stuff )
create tileprops  s" tileprops.dat" >data file,
:make tileprops@  >gid dup if 2 - 1i tileprops + c@ then ;
:make on-tilemap-collide  onmaphit @ ?dup if >r then ; 
: /solid   16 16 mbw 2! physics> tilebuf collide-tilemap ;

( curtain open effect )
: *curtain  stage one draw> 128 256 black rectf ;
: curtain-open
    0 64 at *curtain 64 live-for -2 vx !
    128 64 at *curtain 64 live-for 2 vx !
; 

( canned motions )
: orbit  ( n )
    !startxy
    perform> 0 begin
        dup 16 vec startx 2@ 2+ x 2! over +
    pause again ;

( actor directional stuff )
var olddir
action evoke-direction  ( - )
: !face  ( - ) dir @ olddir !  evoke-direction ; 
: downward  ( - ) 90 dir ! !face ;
: upward    ( - ) 270 dir ! !face ;
: leftward  ( - ) 180 dir ! !face ;
: rightward ( - ) 0 dir !   !face ;
: ?face     ( - ) dir @ olddir @ = ?exit !face ;    
: dir-anim-table  ( - )  does> dir @ 90 / cells + @ execute ;
    
( item stuff )
include sample/zelda/item-assets.f
256 cells quest-field inventory
: /item  items.image img !  #item +flag ;
: item[]  ( n - adr ) cells inventory + ;
: get  ( qty role - ) role>type item[] +! ;
: .item  ( obj - )  dup .type  ."  qty: " 's qty ? ;
: pickup ( obj - ) >{ cr ." Picked up: " me .item  qty @ role @ get dismiss } ;
: have  ( role - n )  role>type item[] @ ;

( npc's )
16 16 s" npc.png" >data tileset: npc.png
: /npc  #npc flags !  npc.png img ! ;

( object types - maintain the ordering to keep savestates coherent )
type: link
type: test
type: sword
type: bomb
type: potion
type: rupee
type: orb
type: statue
type: swordattack
type: dude

: body>name  body> >name ccount ;
: load-types  typeRoles each> body>name s" sample/zelda/obj/" s[ +s s" .f" +s ]s included ;
load-types

( extend loop )
: think  ( - ) stage acts  tasks multi  stage multi  tasks acts ;
: physics ( - ) stage each> as ?physics vx 2@ x 2+! ;
: zelda-step ( - ) step> think physics interact sweep ;
: zelda-show  ( - ) show> ramenbg upscale> stage draws ;
zelda-step zelda-show

( user interface )
: /bg   bg0 as /tilemap 256 256 w 2! ; <ui
: /cam  cam as act> x 2@ bg0 's scrollx 2! ; <ui
: /hud  hud as bg0 's x @ 0 x 2! draw> black 256 64 rectf ; <ui
: urhere  at@ x 2@ coords 2@ 4 4 2* 2+ at 5 5 rectf at ; <ui
: mapgrid
    8 for
        16 for
            5 5 rect
            4 0 +at
        loop
        4 -16 * 4 +at
    loop
;
: /minimap  minimap as hud 16 16 from situate draw> red urhere grey mapgrid ; <ui

( map data )
world: overworld overworld <ui
world: underworld <ui

16 8 overworld rooms:
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $11 , $10 , $01 , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $00 , $31 , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 
$FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , $FF , 

( game modes )
: /ui  /hud /minimap ;
: /playfield  /bg /cam /ui ;
: /overworld
    /playfield
    /link 64 96 x 2!
    overworld 
;

( additional events )
include sample/zelda/events.f


( exported game initialization )
:make cold
    reload                   \ reload the tilemap data
;


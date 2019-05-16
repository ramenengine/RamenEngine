include ramen/ramen.f
empty
depend ramen/basic.f
depend ramen/lib/std/tilecol.f
project: ex/mushrooms
320 240 resolution

( variables )
128 128 * array: tilebuf
:make loc  ( col row array2d - adr )  >r 2pfloor 128 * + r> [] ;

( draw tiles )
0 value tilebank  \ image
: ?skip  dup ?exit  drop  r> drop ;
: tile  ?skip 1 - >r tilebank >bmp r> tilebank subxywh 0 bblit ;
: tile+  tile 16 0 +at ;

( load tileset )
16 16 s" mushroom-bg.png" >datapath tileset: mushroom-bg.png
mushroom-bg.png to tilebank

( tilemap renderer )
_actor fields:  var scrollx var scrolly

: scrolled  ( - col row )
    scrollx 2@ 0 0 2max scrollx 2!
    scrollx 2@ 16 16 2mod 2negate +at
    scrollx 2@ 16 16 2/ 2pfloor ;
    
: tilemap  ( col row - )
    tilebuf loc
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
mushroom-plants.png 1 8 / autoanim: /grass.anim 0 , 1 , 2 , 1 , ;anim
: /grass  /grass.anim ;

( flower )
mushroom-plants.png 1 8 / autoanim: /flower.anim 3 , 4 , 5 , 4 , ;anim
: /flower  /flower.anim ;

( load map )
: thinout  each> { dyn @ if me dismiss then } ;
: cleanup  stage thinout sweep ;
: ?object  ( tileadr - )
            dup @ 5 = if 8 swap !  one /grass ;then
            dup @ 21 = if 8 swap !  one /flower ;then
            drop
;
: loadmap
    cleanup
    s" stage.tilemap" >datapath 0 tilebuf [] tilebuf length cells @file
    128 for
        128 for
            i j 16 16 2* at  
            i j tilebuf loc
            ?object
        loop
    loop
;


( map editing tools )
: savemap  ( - )
    0 0 tilebuf loc
        tilebuf length cells
        s" stage.tilemap" >datapath
        file! ;




( setup the stage. )
stage actor: bg  /bg
stage actor: cam  /pan 
: /cam   draw>
    me stage push
    x 2@ 0 0 2max x 2!
    x 2@ bg 's scrollx 2!
    cam 's x 2@ bg 's x 2!
; /cam

\ replace the renderer
:now  show> ramenbg mount cam as view> stage draws ;

loadmap


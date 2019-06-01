_actor fields:
    var scrollx var scrolly
    var w var h
    
128 128 * array: tilebuf
:make loc  ( col row array2d - adr )  >r 2pfloor 128 * + r> [] ;

( variables )
stage actor: bg 
[undefined] p1 [if] stage actor: p1 [then]
stage actor: cam   viewwh w 2!
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
: tile   ?skip 1 - >r bank >bmp r> bank subxywh 0 bblit ;
: tile+  tile 16 0 +at ;

0 tile

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

( shadows )
: -at  2negate +at ;
: shadow     2>r tint 4@ 0 0 0 1 tint 4! 2r@ +at sprite 2r> -at tint 4! ;
: /shadowed  draw> 1 1 shadow sprite ;

\ renderer; apply view transform at camera's pov
: y!z  stage each> as  y @ spriteh + zorder ! ;
: !forcez  bg as  0 zorder ! ;
: playfield  cam as view> y!z !forcez hold> stage draws ;

( init )
: /gfx
    bg stage push
    p1 stage push
    cam stage push
    show> ramenbg mount update-camera playfield 
;
/gfx 
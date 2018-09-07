\ Sprite objects!
\ - Render subimages or image regions
\ - Define animation data and animate sprites

require ramen/lib/draw

\ Region tables
6 cells constant /region
    \ x , y , w , h , originx , originy , 

3 cells constant /frame
    \ index+flip , ofsx , ofsy , 
    \ hflip = $1
    \ vflip = $2
    \ index is fixed point

redef on
    \ Transformation info; will be factored out into Ramen's core eventually
    var sx  var sy  var ang  var cx  var cy
    color sizeof field tint  \ NOTE: not automatically used.  

    \ animation state:
    var img  var frm  var rgntbl  var anmspd  var anmctr    \ all can be modified freely.  only required value is ANM.
redef off

defaults >{
    1 1 sx 2!
    1 1 1 1 tint 4!
    1 anmspd !
}

\ Drawing
: sprite ( srcx srcy w h flip )  \ pass a rectangle defining the region to draw
    locals| flip h w y x |
    img @ >bmp  x y w h 4af  fore 4@  cx 2@  at@  4af  sx 3@ 3af  flip
        al_draw_tinted_scaled_rotated_bitmap_region ;
: objsubimage  ( image n flip -- )  >r  over >subxywh  r> sprite ;

\ Get current frame data
: ?regorg  rgntbl @ ?dup -exit  frm @ @  /region * + 4 cells + 2@ 2negate +at ;

: >framexywh  ( n rgntbl -- srcx srcy w h )
    swap /region * +  4@ ;

: curframe  ( -- srcx srcy w h )
    frm @ 0= if  0 0 img @ imagewh  exit then 
    rgntbl @ if
        frm @ @  rgntbl @  >framexywh
    else
        frm @ @  img @  >subxywh
    then ;
: curflip  frm @ @ #3 and ;

\ Draw + animate
defer animlooped ( -- )  :is animlooped ;  \ define this in your app to do stuff every time an animation ends/loops
: sprite+  ( -- )

    frm @ 0= if  curframe  curflip sprite  exit  then 
    at@ 
        frm @ cell+ 2@ +at  \ apply the frame offset
        ?regorg  \ apply the region origin
        img @ if  curframe  curflip sprite  then
        anmspd @ anmctr +!
        begin  anmctr @ 1 >= while
            anmctr --  /frame frm +!
            frm @ @ $deadbeef = if  frm @ cell+ @ frm +!  animlooped  then
        repeat
    at  \ restore pen
;

\ Play an animation.
\ ?/st      ( -- )  first time call initializes scale and tint
\ animate   ( anim -- )  play animation from beginning
: animate   frm !  0 anmctr !  frm @ -exit  draw> sprite+ ;
    
\ Define self-playing animations
\ anim:  ( regiontable|0 image speed -- loopaddr )  ( -- )  create self-playing animation
: anim:  create  3,  here  does>  @+ rgntbl !  @+ img !  @+ anmspd !   animate ;
: frames,  for  3dup 3, loop 3drop  ;
: loop:  drop here ;
: ;anim  ( loopaddr -- )  here -  $deadbeef ,  , ;
: animrange,  ( start len -- ) over + swap do  i , 0 , 0 ,  loop  ;

\ +anim:  ( stack -- stack loopaddr )  animation table helper
: +anim:  here over push here ;

\ frames  ( str c -- regiontable image )  Helper for doing unnamed images + region tables
: frames  image  here  swap ;

\ flipped frame utilities
: h,  #1 or , ;
: v,  #2 or , ;
: hv, #3 or , ;

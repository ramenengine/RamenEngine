\ Sprite objects!
\ - Render subimages or image regions
\ - Define animation data and animate sprites

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
    color sizeof field tint

    \ animation state:
    var img  var anm  var rgntbl  var anmspd  var anmctr    \ all can be modified freely.  only required value is ANM.
redef off

\ Drawing
: sprite ( image srcx srcy w h flip )  \ pass a rectangle defining the region to draw
    locals| flip h w y x |
    image.bmp @  x y w h 4af  tint 4@ 4af  cx 2@  at@  4af  sx 3@ 3af  flip
        al_draw_tinted_scaled_rotated_bitmap_region ;
: objsubimage  ( image n flip -- )  >r  over >subxywh  r> sprite ;

\ Get current frame data
: ?regorg  rgntbl @ ?dup -exit  anm @ @  /region * + 4 cells + 2@ 2negate +at ;
: curframe  ( -- srcx srcy w h )
    rgntbl @ ?dup if
        anm @ @  /region * +  4@
    else
        anm @ @  img @  >subxywh
    then ;
: curflip  anm @ @ #3 and ;

\ Draw + animate
defer animlooped ( -- )  :is animlooped ;  \ define this in your app to do stuff every time an animation ends/loops
: sprite+  ( -- )
    anm @ -exit
    at@ 
        anm @ cell+ 2@ +at  \ apply the frame offset
        ?regorg  \ apply the region origin
        img @ ?dup if  curframe  curflip sprite  then
        anmspd @ anmctr +!
        begin  anmctr @ 1 >= while
            anmctr --  /frame anm +!
            anm @ @ $deadbeef = if  anm @ cell+ @ anm +!  animlooped  then
        repeat
    at  \ restore pen
;

\ Play an animation.
\ /scale    ( -- )  init scale to 1,1
\ /tint     ( -- )  init tint to white
\ ?/st      ( -- )  first time call initializes scale and tint
\ animate   ( anim -- )  play animation from beginning
: /scale    1 1 sx 2! ;
: /tint     1 1 1 1 tint 4! ;
: ?/st      anm @ ?exit  /scale  /tint ;
: animate   ?/st  anm !  0 anmctr !  draw> sprite+ ;
    
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

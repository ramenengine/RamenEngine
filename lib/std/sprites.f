\ Sprite objects!
\ - Render subimages or image regions
\ - Define animation data and animate sprites

defer animlooped ( - )  :is animlooped ;  \ define this in your app to do stuff every time an animation ends/loops

\ Region tables
6 cells constant /region
    \ x , y , w , h , originx , originy , 

cell constant /frame
    \ index+flip , ...
        \ hflip = $1
        \ vflip = $2
        \ index is fixed point

redef on
    \ Transformation info; will be factored out into Ramen's core eventually
    var sx  var sy  var ang  var cx  var cy
    %color sizeof field tint

    \ animation state:
    var img  var frm  var rgntbl  var anmspd  var anmctr    \ all can be modified freely.  only required value is ANM.
redef off

defaults >{
    1 1 sx 2!
    1 1 1 1 tint 4!
    1 anmspd !
}

\ Drawing
: sprite ( srcx srcy w h flip )
    locals| flip h w y x |
    img @ >bmp  x y w h 4af  tint 4@ 4af  cx 2@  destxy  4af  sx 2@ 2af
    ang @ >rad 1af  flip
        al_draw_tinted_scaled_rotated_bitmap_region ;

: subsprite  ( n flip - )   \ note: IMG must be subdivided
    >r  img @ subxywh  r> sprite ;      

\ Get current frame data

: framexywh  ( n rgntbl - srcx srcy w h )
    swap /region * +  4@ ;

: curframe  ( - srcx srcy w h )
    frm @ 0= if
        img @ image.subcount @ if
            0 img @ subxywh
        else
            0 0 img @ imagewh
        then
    exit then 
    rgntbl @ if
        frm @ @  rgntbl @  framexywh
    else
        frm @ @  img @  subxywh
    then ;

: curflip  frm @ if frm @ @ #3 and exit then  0 ;

\ Draw + animate
define internal
    : ?regorg  ( - )  \ apply the region origin
        rgntbl @ ?dup -exit
        frm @ @  /region * + 4 cells + 2@ cx 2! ;
using internal
: sprite+  ( - )
    frm @ 0= if  curframe  curflip sprite  exit  then 
    at@ 
        ?regorg  
        img @ if curframe curflip sprite then
        anmspd @ anmctr +!
        \ looping
        begin  anmctr @ 1 >= while
            anmctr -  /frame frm +!
            frm @ @ $deadbeef = if  frm @ cell+ @ frm +!  animlooped  then
        repeat
    at  
;
previous

\ Play an animation.
\ animate   play animation from beginning
: animate   ( anim - )  frm !  0 anmctr ! ;
    
\ Define self-playing animations
\ anim:  create self-playing animation
: anim:  ( regiontable|0 image speed - loopaddr )  ( - )  
    create  3,  here
    does>  @+ rgntbl ! @+ img ! @+ anmspd ! animate ;
: ,,  for  dup , loop drop  ;
: loop:  drop here ;
: ;anim  ( loopaddr - )  here -  $deadbeef ,  , ;
: range,  ( start len - ) bounds do i , loop ;

\ +anim:  animation table helper
\ frames  Helper for doing unnamed images + region tables

: +anim:  ( stack - stack loopaddr )     here over push here ;
: frames  ( str c - regiontable image )  image  here  swap ;

\ flipped frame utilities
: h,  #1 or , ;
: v,  #2 or , ;
: hv, #3 or , ;

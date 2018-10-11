\ Sprite objects!
\ - Render subimages or image regions
\ - Define animation data and animate sprites

depend ramen/lib/draw.f

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
: sprite ( srcx srcy w h flip )
    locals| flip h w y x |
    img @ >bmp  x y w h 4af  tint 4@ 4af  cx 2@  destxy  4af  sx 2@ 2af
    ang @ >rad 1af  flip
        al_draw_tinted_scaled_rotated_bitmap_region ;

: subsprite  ( n flip -- )  >r  img @ subxywh  r> sprite ;  
    \ img must be subdivided

\ Get current frame data
: ?regorg
    rgntbl @ ?dup -exit
    frm @ @  /region * + 4 cells + 2@ cx 2! ;

: framexywh  ( n rgntbl -- srcx srcy w h )
    swap /region * +  4@ ;

: curframe  ( -- srcx srcy w h )
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
defer animlooped ( -- )  :is animlooped ;  \ define this in your app to do stuff every time an animation ends/loops
: sprite+  ( -- )

    frm @ 0= if  curframe  curflip sprite  exit  then 
    at@ 
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
: animate   frm !  0 anmctr ! ;
    
\ Define self-playing animations
\ anim:  ( regiontable|0 image speed -- loopaddr )  ( -- )  create self-playing animation
: anim:  create  3,  here  does>  @+ rgntbl !  @+ img !  @+ anmspd !   animate ;
: ,,  for  dup , loop drop  ;
: loop:  drop here ;
: ;anim  ( loopaddr -- )  here -  $deadbeef ,  , ;
: range,  ( start len -- ) over + swap do  i , 0 , 0 ,  loop  ;

\ +anim:  ( stack -- stack loopaddr )  animation table helper
: +anim:  here over push here ;

\ frames  ( str c -- regiontable image )  Helper for doing unnamed images + region tables
: frames  image  here  swap ;

\ flipped frame utilities
: h,  #1 or , ;
: v,  #2 or , ;
: hv, #3 or , ;

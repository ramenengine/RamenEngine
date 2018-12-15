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
    var sx  var sy              \ scale
    var ang                     \ rotation
    var cx  var cy              \ center
    %color sizeof field tint

    \ animation state; all can be modified freely.  only required value is IMG.
    var img <adr  \ image asset
    var frmptr <adr  \ frame pointer
    var rgntbl <adr \ region table
    var anmspd    \ animation speed (1.0 = normal, 0.5 = half, 2.0 = double ...)
    var anmctr    \ animation counter
redef off

defaults >{
    1 1 sx 2!
    1 1 1 1 tint 4!
    1 anmspd !
}

\ Drawing
: sprite ( srcx srcy w h flip )
    locals| flip h w y x |
    img @ -exit
    img @ >bmp  x y w h 4af  tint 4@ 4af  cx 2@  destxy  4af  sx 2@ 2af
    ang @ >rad 1af  flip
        al_draw_tinted_scaled_rotated_bitmap_region ;

: framexywh  ( n rgntbl - srcx srcy w h )
    swap /region * + 4@ ;

: >region  ( n - srcx srcy w h )
    img @ 0= if 0 0 0 0 ;then
    frmptr @ 0= if
        img @ image.subcount @ if
            img @ subxywh
        else
            drop 0 0 img @ imagewh
        then
    ;then 
    rgntbl @ if
        rgntbl @ framexywh
    else
        img @ subxywh
    then ;

: curflip  frmptr @ if frmptr @ @ #3 and ;then  0 ;

:slang ?regorg  ( - )  \ apply the region origin
    rgntbl @ -exit frmptr @ -exit
    rgntbl @  frmptr @ @  /region * + 4 cells + 2@ cx 2! ;

: nsprite  ( n - )   \ note: IMG must be subdivided and/or RGNTBL must be set. (region table takes precedence.)
    ?regorg >region curflip sprite ;

: animate  ( - )  \ Advance the animation
    frmptr @ -exit anmspd @ -exit
    anmspd @ anmctr +!
    \ looping
    begin  anmctr @ 1 >= while
        -1 anmctr +!  /frame frmptr +!
        frmptr @ @ $deadbeef = if  frmptr @ cell+ @ frmptr +!  animlooped  then
    repeat
;
 
: frame@  ( - n | 0 )  \ 0 if frmptr is null
    frmptr @ dup if @ then ;

: sprite+  ( - )  \ draw and advance the animation
    frame@ nsprite animate ;

\ Play an animation from the beginning
: portray  ( anim - )  frmptr !  0 anmctr ! ;
    
\ Define self-playing animations
\ anim:  create self-playing animation
: anim:  create  3,  here ;
: autoanim:  ( regiontable|0 image speed - loopaddr )  ( - )  
    anim: does>  @+ rgntbl ! @+ img ! @+ anmspd !  portray ;
: ,,  for  dup , loop drop  ;
: loop:  drop here ;
: ;anim  ( loopaddr - )  here -  $deadbeef ,  , ;
: range,  ( start len - ) bounds do i , loop ;

\ flipped frame utilities
: h,  #1 or , ;
: v,  #2 or , ;
: hv, #3 or , ;

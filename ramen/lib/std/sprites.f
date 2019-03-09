( Sprite objects )

\ animation format:
\    region table,
\    image,
\    speed,
\    <...frame indices...>,
\    $DEADBEEF,
\    offset to loop start, (from location of $DEADBEEF)

defer animlooped ( - )  :make animlooped ;  \ define this in your app to do stuff every time an animation ends/loops

\ Region tables
6 cells constant /region
    \ x , y , w , h , originx , originy , 

cell constant /frame
    \ index+flip , ...
        \ hflip = $1
        \ vflip = $2
        \ index is fixed point

extend: _actor
    \ Transformation info
    var sx  var sy              \ scale
    var ang                     \ rotation
    var cx  var cy              \ center
    %color sizeof field tint

    \ animation state; all can be modified freely.  only required value is IMG.
    var img <body \ image asset
    var anm <adr  \ animation base
    var spr       \ sprite index
    var anmspd    \ animation speed (1.0 = normal, 0.5 = half, 2.0 = double ...)
    var anmctr    \ animation counter
;class

_actor prototype as
    1 1 sx 2!
    1 1 1 1 tint 4!
    1 anmspd !

( Drawing )
: bsprite ( srcx srcy w h flip )
    locals| flip h w y x |
    img @ -exit
    img @ >bmp  x y w h 4af  tint 4@ 4af  cx 2@  destxy  4af  sx 2@ 2af
    ang @ >rad 1af  flip
        al_draw_tinted_scaled_rotated_bitmap_region ;

( Frame stuff )
: rgntbl  img @ image.regions ;

: framexywh  ( n rgntbl - srcx srcy w h )
    swap /region * + 4@ ;

: >region  ( n - srcx srcy w h )
    img @ 0= if 0 0 0 0 ;then
    rgntbl @ if
        rgntbl @ framexywh
    ;then
    img @ image.subw @ if
        img @ subxywh
    else
        0 0 img @ imagewh
    then
;

( Animation )
: frame[]  ( anm - adr )
    ( skip the settings ) 2 cells + anmctr @ pfloor /frame * + ;

: curflip  ( index - index n )
    anm @ if anm @ frame[] @ #3 and ;then  dup 3 and ;

: ?regorg  ( index - index )  \ apply the region origin
    img @ -exit  rgntbl @ -exit
    rgntbl @ over /region * + 4 cells + 2@ cx 2! ;

: frame@  ( - n | 0 )  \ 0 if anm is null
    anm @ dup if frame[] @ then ;

\ NSPRITE
\ draw a sprite either from a subdivided image, animation, or image plus region table.
\ if there's no animation, you can pack the flip info into the index. (lower 2 bits)
\ IMG must be subdivided and/or it must have a region table. (region table takes precedence.)
\ if neither, then the whole IMG will be drawn
: nsprite  ( index - )   
    anm @ if spr ! frame@ then
    ?regorg >region curflip bsprite ;

: +frame  ( speed - )  \ Advance the animation
    ?dup -exit anm @ -exit 
    anmctr +!
    ( looping: )
    frame@ $deadbeef = if  anm @ frame[] cell+ @ anmctr +!  animlooped  then
;
 
: sprite  ( - )  \ draw sprite and advance the animation if any
    frame@ nsprite anmspd @ +frame ;

\ Play an animation from the beginning, using its settings
: animate  ( anim - )
    dup anm !  @+ img ! @+ anmspd !   drop  0 anmctr ! ;
    
\ Define animations
: anim:  ( image speed - <name> loopadr )
    create  2,  here ;
: autoanim:  ( image speed - <name> loopadr ) ( - )
    anim: does> animate ;
    
: ,,  for  dup , loop drop  ;
: loop:  drop here ;
: ;anim  ( loopaddr - )  $deadbeef ,  here -  /frame i/ 1p 1 + , ;
: range,  ( start len - ) bounds do i , loop ;

\ flipped frame utilities
: ,h  #1 or , ;
: ,v  #2 or , ;
: ,hv #3 or , ;

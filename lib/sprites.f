$0000100 [version] sprites-ver

\ Sprite objects!
\ - Render subimages or image regions
\ - Define animation data and animate sprites

redef on
    \ Transformation info; will be factored out eventually
    var sx  var sy  var ang  var cx  var cy
    color sizeof field tint
    0 field animstate
    var img  var anm  var rgntbl  var anmspd  var ctr  \ don't change the order of the first four...
redef off

\ right now sx and sy need to be initialized to 1,1 , and tint needs to be initialized to 1,1,1,1
\ this is just until we add prototypes to obj.f ...
: /scalerot  1 1 sx 2!  1 1 1 1 tint 4! ;

\ Play an animation.  Note if ANMSPD is zero the animation will start "paused"
: animate  ( image anim -- )  animstate 2!  0 ctr ! ;

\ --------------------------------------------------------------------------------------------------
\ Drawing!

: objsubimage  ( image n flip -- )  \ uses image subdivision feature
    >r swap afsubimg
        tint 4@ 4af  cx 2@ at@  4af  sx 3@ 3af  r>
        al_draw_tinted_scaled_rotated_bitmap_region ;


: objregion ( image rect flip )  \ pass a rectangle defining the region to draw
    locals| flip rect img |  img >bmp ?exit
    img image.bmp @  rect 4@ 4af  tint 4@ 4af  cx 2@ at@  4af  sx 3@ 3af  flip
        al_draw_tinted_scaled_rotated_bitmap_region ;

\ --------------------------------------------------------------------------------------------------
\ Define region tables.

: region,  ( x y w h )  4,  0 , 0 , ;
: <origin  ( x y )  2negate  here 2 cells - 2! ;
6 cells constant /region

\ --------------------------------------------------------------------------------------------------
\ Define animations

3 cells constant /frame
: anim[  0 0 at  here ;
: anim:  ( image speed regiontable|0 -- loopaddr )  ( -- )  \ when defined word is called, animation plays
    create  3,  anim[  does>  @+ swap @+ anmspd ! @+ rgntbl ! swap animate ;
: frame,  ( index+flip -- )  , at@ 2, ;
: frames,  0 do dup frame, loop drop  ;
: [h]  #1 or ;
: [v]  #2 or ;
: loop:  drop here ;
: ;anim  ( loopaddr -- )  here -  $deadbeef ,  , ;

: animrange:  ( start len -- <name> )
    anim:  over + swap do  i frame,  loop  ;anim ;

: animtable[  ( var size -- addr )  cellstack dup rot ! ;
: ]animtable  drop ;
: subanim[  here over push  anim[ ;
: ]subanim  ;anim ;

: frame@  ( -- srcx srcy w h )
    img @ anm @ or 0= if  0 0 16 16  exit then
    rgntbl @ ?dup if
        anm @ @  /region * +  4@
    else
        anm @ @  img @  >subxywh
    then ;


\ --------------------------------------------------------------------------------------------------
\ Drawing and pulsing animation

action animlooped ( -- )

: animspr  ( -- )
    anm @ -exit  img @ -exit
    anm @ cell+ 2@ +at  \ apply the offset
    img @
        rgntbl @ ?dup if
            anm @ @ dup >r  /region * +  r>  #3 and  objregion
        else
            anm @ @ dup #3 and   objsubimage
        then
    anmspd @ ctr +!
    begin  ctr @ 1 >= while
        ctr --  /frame anm +!
        anm @ @ $deadbeef = if  anm @ cell+ @ anm +!  animlooped  then
    repeat
;


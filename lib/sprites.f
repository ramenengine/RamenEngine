
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

: sprite ( image srcx srcy w h flip )  \ pass a rectangle defining the region to draw
    locals| flip h w y x img |  img >bmp ?exit
    img image.bmp @  x y w h 4af  tint 4@ 4af  cx 2@ at@  4af  sx 3@ 3af  flip
        al_draw_tinted_scaled_rotated_bitmap_region ;

: objsubimage  ( image n flip -- )  >r  over >subxywh  r> sprite ;

\ --------------------------------------------------------------------------------------------------
\ Region tables.

6 cells constant /region
    \ x , y , w , h , originx , originy , 

\ --------------------------------------------------------------------------------------------------
\ Define animations

3 cells constant /frame
    \ index+flip , ofsx , ofsy , 
    \ hflip = $1
    \ vflip = $2
    \ index is fixed point

: anim:  ( image speed regiontable|0 -- loopaddr )  ( -- )  \ when defined word is called, animation plays
    create  3,  here
    does>  @+ swap @+ anmspd ! @+ rgntbl ! swap animate ;
: frames,  for  3dup 3, loop 3drop  ;
: loop:  drop here ;
: ;anim  ( loopaddr -- )  here -  $deadbeef ,  , ;

: animrange,  ( start len -- ) over + swap do  i , 0 , 0 ,  loop  ;
: addanim:  ( cellstack -- cellstack loopaddr ) here over push here ;


\ --------------------------------------------------------------------------------------------------
\ Drawing and pulsing animation

\ Get current frame
: curframe  ( -- srcx srcy w h )
    img @ anm @ or 0= if  0 0 16 16  exit then
    rgntbl @ ?dup if
        anm @ @  /region * +  4@
    else
        anm @ @  img @  >subxywh
    then ;

action animlooped ( -- )

\ Draw + animate
: animspr  ( -- )
    anm @ -exit  img @ -exit
    anm @ cell+ 2@ +at  \ apply the offset
    img @  curframe  anm @ @ #3 and  sprite
    anmspd @ ctr +!
    begin  ctr @ 1 >= while
        ctr --  /frame anm +!
        anm @ @ $deadbeef = if  anm @ cell+ @ anm +!  animlooped  then
    repeat
;


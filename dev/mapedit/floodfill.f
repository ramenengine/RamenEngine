0 value fill-color
0 value stop-color
0 value area-color

: target al_get_target_bitmap ;

: (outline-fill)   ( x y -- )
   locals| y x |
   x 0< ?exit
   y 0< ?exit
   x target bmpw >= ?exit
   y target bmph >= ?exit
   x y at pixel
   dup @ dup fill-color = swap stop-color = or if drop ;then
   fill-color swap !
   x 1 + y recurse
   x y 1 + recurse
   x 1 - y recurse
   x y 1 - recurse ;

: outline-fill  ( bitmap fill-color stop-color -- )
   to stop-color to fill-color rot to s
   at@ (outline-fill) ;


: (flood-fill)   ( x y -- )
   locals| y x |
   x 0< if exit then
   y 0< if exit then
   x s ->w @ >= if exit then
   y s ->h @ >= if exit then
   s x y sdl-pixel dup @ dup fill-color = swap area-color <> or if drop exit then
   fill-color swap !
   x 1+ y recurse
   x y 1+ recurse
   x 1- y recurse
   x y 1- recurse ;

: floodfill  ( surface x y fill-color -- )
   to fill-color rot to s
   2dup sdl-pixel @ to area-color
   (flood-fill) ;
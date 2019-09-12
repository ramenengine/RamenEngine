
asset: %image
    %image svar image.bmp
    %image svar image.subw
    %image svar image.subh
    %image svar image.subcols
    %image svar image.subrows
    %image svar image.subcount
    %image svar canvas.w
    %image svar canvas.h
    %image svar image.regions
    

\ get dimensions, fixed point
: imagew   image.bmp @ bmpw ;
: imageh   image.bmp @ bmph ;
: imagewh  image.bmp @ bmpwh ;

\ reload-image  ( image - )  (re)load from file
\ init-image  ( path c image - )  normal asset init 
\ image:  ( path c - <name> )  declare named image.  
\ >bmp  ( image - ALLEGRO_BITMAP )
\ load-image  ( path c image - ) 
\ free-image  ( image - )  

: reload-image  >r  r@ srcfile count  findfile  zstring al_load_bitmap  r> image.bmp ! ;
: unload-image  image.bmp @ al_destroy_bitmap ;
: init-image  >r  r@ srcfile place  ['] reload-image ['] unload-image r@ register  r> reload-image ;
: image:  create  %image *struct init-image  ;
: >bmp  dup if image.bmp @ ;then ;
: free-image  image.bmp @ -bmp ;
: load-image  dup free-image init-image ;

\ Canvas (images without source files)

\ recreate-canvas  ( image - )
\ resize-canvas  ( w h image - )
\ init-canvas  ( w h image - )
\ canvas:  ( w h - <name> )

: recreate-canvas  #24 al_set_new_bitmap_depth  >r  r@ canvas.w 2@ 2i al_create_bitmap  r> image.bmp ! ;
: unload-canvas  unload-image ;
:slang ?samesize  >r  2dup r@ canvas.w 2@ d= if  2drop  r> r> 2drop  exit then  r> ;
: resize-canvas  ?samesize  >r r@ free-image  r@  canvas.w 2!  r> recreate-canvas ;
: init-canvas  >r    ['] recreate-canvas ['] unload-canvas r@ register  r@  canvas.w 2!  r> recreate-canvas ;
: canvas:  create  %image *struct init-canvas  ;

\ Sub-image stuff

\ subdivide  ( tilew tileh image - )  calculate subimage parameters
\ subxy  ( n img - x y )  locate a subimg by index
\ subxywh  ( n img - x y w h )  get full rect of subimage
: subdivide  
    >r  2dup r@ image.subw 2!  
    r@ imagewh  r@ image.subw 2@  2/ 2pfloor  r@ image.subcols 2!
    *  r> image.subcount ! ;
: subxy  >r  pfloor  r@ image.subcols @  /mod  2pfloor  r> image.subw 2@ 2* ;
: subwh   image.subw 2@ ;
: subxywh  dup >r  subxy r> subwh ;

: tileset:  ( tilew tileh imagepath c - <name> )
    image: lastbody subdivide ;

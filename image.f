
defasset %image
    %image svar image.bmp
    %image svar image.subw
    %image svar image.subh
    %image svar image.subcols
    %image svar image.subrows
    %image svar image.subcount
    %image svar canvas.w
    %image svar canvas.h
    

\ get dimensions, fixed point
: imagew   image.bmp @ bmpw ;
: imageh   image.bmp @ bmph ;
: imagewh  image.bmp @ bmpwh ;

\ reload-image  ( image - )  (re)load from file
\ init-image  ( path c image - )  normal asset init 
\ image  ( path c - image )  create unnamed image.  (redefining IMAGE is a nice way of "sealing" the struct.)
\ image:  ( path c - <name> )  declare named image.  
\ >bmp  ( image - ALLEGRO_BITMAP )
: reload-image  >r  r@ srcfile count  findfile  zstring al_load_bitmap  r> image.bmp ! ;
: init-image  >r  r@ srcfile place  ['] reload-image r@ register  r> reload-image ;
: image   here >r  %image sizeof allotment init-image  r> ; 
: image:  create  image  drop ;
: >bmp  image.bmp @ ;

\ load-image  ( path c image - ) 
\ free-image  ( image - )  
: load-image  >r  zstring al_load_bitmap  r> init-image ;
: free-image  image.bmp @ -bmp ;

\ Canvas (images without source files)

\ recreate-canvas  ( image - )
\ resize-canvas  ( w h image - )
\ init-canvas  ( w h image - )
\ canvas  ( w h - image )
\ canvas:  ( w h - <name> )
: recreate-canvas  #24 al_set_new_bitmap_depth  >r  r@ canvas.w 2@ 2i al_create_bitmap  r> image.bmp ! ;
:slang ?samesize  >r  2dup r@ canvas.w 2@ d= if  2drop  r> r> 2drop  exit then  r> ;
: resize-canvas  ?samesize  >r r@ free-image  r@  canvas.w 2!  r> recreate-canvas ;
: init-canvas  >r    ['] recreate-canvas r@ register  r@  canvas.w 2!  r> recreate-canvas ;
: canvas  here >r  %image sizeof allotment init-canvas  r> ;
: canvas:  create  canvas  drop  ;

\ Sub-image stuff

\ subdivide  ( tilew tileh image - )  calculate subimage parameters
\ subxy  ( n img - x y )  locate a subimg by index
\ subxywh  ( n img - x y w h )  get full rect of subimage
\ imgsubbmp  ( n img - subbmp )  create a sub-bitmap from a subimage
: subdivide  
    >r  2dup r@ image.subw 2!  
    r@ imagewh  r@ image.subw 2@  2/ 2pfloor  r@ image.subcols 2!
    *  r> image.subcount ! ;
: subxy  >r  pfloor  r@ image.subcols @  /mod  2pfloor  r> image.subw 2@ 2* ;
: subxywh  dup >r  subxy r> image.subw 2@ ;
: imgsubbmp  dup >bmp  -rot  subxywh 4i  al_create_sub_bitmap ;

: tileset:  ( tilew tileh imagepath c - <name> )
    image: lastbody subdivide ;

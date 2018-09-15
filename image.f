\ first let's make these words work in fixed point!
: bmpw  al_get_bitmap_width 1p ;
: bmph  al_get_bitmap_height 1p ;
: bmpwh  dup bmpw swap bmph ;

assetdef %image
    %image 0 svar image.bmp
    %image 0 svar image.subw
    %image 0 svar image.subh
    %image 0 svar image.fsubw
    %image 0 svar image.fsubh
    %image 0 svar image.subcols
    %image 0 svar image.subrows
    %image 0 svar image.subcount
    %image 0 svar canvas.w
    %image 0 svar canvas.h
    

\ get dimensions, fixed point
: imagew   image.bmp @ bmpw ;
: imageh   image.bmp @ bmph ;
: imagewh  image.bmp @ bmpwh ;

\ reload-image  ( image -- )  (re)load from file
\ init-image  ( path c image -- )  normal asset init 
\ image  ( path c -- image )  create unnamed image.  (redefining IMAGE is a nice way of "sealing" the struct.)
\ image:  ( path c -- <name> )  declare named image.  
\ >bmp  ( image -- ALLEGRO_BITMAP )
: reload-image  >r  r@ srcfile count  findfile  zstring al_load_bitmap  r> image.bmp ! ;
: init-image  >r  r@ srcfile place  ['] reload-image r@ register  r> reload-image ;
: image   here >r  %image sizeof allotment init-image  r> ; 
: image:  create  image  drop ;
: >bmp  image.bmp @ ;

\ load-image  ( path c image -- ) 
\ free-image  ( image -- )  
: load-image  >r  zstring al_load_bitmap  r> init-image ;
: free-image  image.bmp @ -bmp ;

\ Canvas (images without source files)

\ recreate-canvas  ( image -- )
\ resize-canvas  ( w h image -- )
\ init-canvas  ( w h image -- )
\ canvas  ( w h -- image )
\ canvas:  ( w h -- <name> )
: recreate-canvas  >r  r@ canvas.w 2@ 2i al_create_bitmap  r> image.bmp ! ;
: resize-canvas  >r  r@ free-image  r@  canvas.w 2!  r> recreate-canvas ;
: init-canvas  >r    ['] recreate-canvas r@ register  r@  canvas.w 2!  r> recreate-canvas ;
: canvas  here >r  %image sizeof allotment init-canvas  r> ;
: canvas:  create  canvas  drop  ;

\ Sub-image stuff

\ subdivide  ( img tilew tileh -- )  calculate subimage parameters
\ >subxy  ( n img -- x y )  locate a subimg by index
\ >subxywh  ( n img -- x y w h )  get full rect of subimage
\ afsubimg  ( n img -- ALLEGRO_BITMAP fx fy fw fh )  util to help with calling Allegro blit functions
\ imgsubbmp  ( n img -- subbmp )  create a sub-bitmap from a subimage
: subdivide  
    rot >r  2dup r@ image.subw 2!  2af r@ image.fsubw 2!
    r@ imagewh  r@ image.subw 2@  2/ 2pfloor  2dup r@ image.subcols 2!
    *  r> image.subcount ! ;
: >subxy  >r  pfloor  r@ image.subcols @  /mod  2pfloor  r> image.subw 2@ 2* ;
: >subxywh  dup >r  >subxy  r> image.subw 2@ ;
: afsubimg  >r  r@ image.bmp @  swap r@ >subxy 2af  r> image.fsubw 2@ ;
: imgsubbmp  dup image.bmp @ -rot  >subxywh 4i  al_create_sub_bitmap ;

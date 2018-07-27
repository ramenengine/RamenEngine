\ first let's make these words work in fixed point!
: bmpw  al_get_bitmap_width 1p ;
: bmph  al_get_bitmap_height 1p ;
: bmpwh  dup bmpw swap bmph ;

assetdef image
    image int svar image.bmp
    image int svar image.subw
    image int svar image.subh
    image int svar image.fsubw
    image int svar image.fsubh
    image int svar image.subcols
    image int svar image.subrows
    image int svar image.subcount

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
: image   here >r  image sizeof allotment init-image  r> ; 
: image:  create  image  drop ;
: >bmp  image.bmp @ ;

\ load-image  ( path c image -- ) 
\ free-image  ( image -- )  
: load-image  >r  zstring al_load_bitmap  r> init-image ;
: free-image  image.bmp @ -bmp ;


\ Sub-image stuff

\ subdivide  ( tilew tileh img -- )  calculate subimage parameters
\ >subxy  ( n img -- x y )  locate a subimg by index
\ >subxywh  ( n img -- x y w h )  get full rect of subimage
\ afsubimg  ( n img -- ALLEGRO_BITMAP fx fy fw fh )  util to help with calling Allegro blit functions
\ imgsubbmp  ( n img -- subbmp )  create a sub-bitmap from a subimage
: subdivide  
    >r  2dup r@ image.subw 2!  2af r@ image.fsubw 2!
    r@ imagewh  r@ image.subw 2@  2/ 2pfloor  2dup r@ image.subcols 2!
    *  r> image.subcount ! ;
: >subxy  >r  pfloor  r@ image.subcols @  /mod  2pfloor  r> image.subw 2@ 2* ;
: >subxywh  dup >subxy  rot image.subw 2@ ;
: afsubimg  >r  r@ image.bmp @  swap r@ >subxy 2af  r> image.fsubw 2@ ;
: imgsubbmp  dup image.bmp @ -rot  >subxywh 4i  al_create_sub_bitmap ;

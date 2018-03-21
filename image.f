\ make these words work in fixed point!
: bmpw  al_get_bitmap_width 1p ;
: bmph  al_get_bitmap_height 1p ;
: bmpwh  dup bmpw swap bmph ;

struct image
    image int svar image.bmp
    image int svar image.subw
    image int svar image.subh
    image int svar image.fsubw
    image int svar image.fsubh
    image int svar image.subcols
    image int svar image.subrows
    image int svar image.subcount
    image int svar image.orgx          \ initialized to center automatically, but not used by any framework words
    image int svar image.orgy

\ dimensions, fixed point
: imagew   image.bmp @ bmpw 1p ;
: imageh   image.bmp @ bmph 1p ;
: imagewh  image.bmp @ bmpwh ;

: /origin  dup imagewh 0.5 0.5 2* rot image.orgx 2! ;

: init-image ( ALLEGRO_BITMAP image -- )
    >r  r@ image sizeof erase  r@ image.bmp !  r> /origin ;

: $image  here  image sizeof allot  -rot  zstring al_load_bitmap  over init-image ;
: image:  ( path c -- <name> )
    create $image drop ;

: load-image  ( path c image -- )
    >r  zstring al_load_bitmap  r> init-image ;

: free-image  ( image -- ) image.bmp @ -bmp ;

: >bmp  image.bmp @ ;

\ ------------------------------ sub-image stuff -------------------------------
: subdivideimage  ( tilew tileh img -- )
    >r  2dup r@ image.subw 2!  2af r@ image.fsubw 2!
    r@ imagewh  r@ image.subw 2@  2/ 2pfloor  2dup r@ image.subcols 2!
    *  r> image.subcount ! ;

: >subxy  ( n img -- x y )   \ locate a subimg by index
    >r  pfloor  r@ image.subcols @  /mod  2pfloor  r> image.subw 2@ 2* ;

: afsubimg  ( n img -- ALLEGRO_BITMAP fx fy fw fh )   \ helps with calling Allegro blit functions
    >r  r@ image.bmp @  swap r@ >subxy 2af  r> image.fsubw 2@ ;

: subbmp  ( n img -- subbmp )
    >r  r@ image.bmp @  swap r@ >subxy  r> image.subw 2@   4i  al_create_sub_bitmap ;

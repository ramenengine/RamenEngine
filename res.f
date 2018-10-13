: destxy  penx 2@ [undefined] HD [if] 2pfloor [then] ;

: bmpw  dup -exit  al_get_bitmap_width 1p ;
: bmph  dup -exit  al_get_bitmap_height 1p ;
: bmpwh  dup bmpw swap bmph ;

: resolution  ( w h -- ) 2i resolution ;

: nativewh  native 2@ 2p ;

: displayw  display al_get_display_width 1p ;
: displayh  display al_get_display_height 1p ;
: displaywh  displayw displayh ;

: globalscale  #globalscale 1p ;
: viewwh  res xy@ 2p ;
: vieww  viewwh drop ;
: viewh  viewwh nip ;

: transform:  ( x y sx sy ang -- <name> )
    >r >r >r >r >r
    create here  /transform allot
    r> r> r> r> 4af r> >rad 1af al_build_transform ;

: fps  fps 1p ;

: gscale  globalscale dup 2* ;

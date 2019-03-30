: destxy  penx 2@ [undefined] HD [if] 2pfloor [then] ;

: bmpw  dup -exit  al_get_bitmap_width 1p ;
: bmph  dup -exit  al_get_bitmap_height 1p ;
: bmpwh  dup bmpw swap bmph ;

: resolution  ( w h - ) 2i 2dup res 2@ d= not if resolution else 2drop then ;

: nativewh  nativewh 2p ;
: nativew  nativew 1p ;
: nativeh  nativeh 1p ;

: displayw  display al_get_display_width 1p ;
: displayh  display al_get_display_height 1p ;
: displaywh  displayw displayh ;

: globalscale  #globalscale 1p ;
: viewwh  res xy@ 2p ;
: vieww  viewwh drop ;
: viewh  viewwh nip ;

: fps  fps 1p ;

: gscale  globalscale dup 2* ;

: mountx mountx 1p ;
: mounty mounty 1p ;
: mountxy mountxy 2p ;
: mountw mountw 1p ;
: mounth mounth 1p ;
: mountwh mountwh 2p ;
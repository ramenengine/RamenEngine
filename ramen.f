include afkit/ans/version.f
#1 0 0 [version]
\ --------------------------------------------------------------------------------------------------

\ AllegroForthKit
#1 0 0 include afkit/afkit.f

\ 
include ramen/plat.f
include afkit/dep/zlib/zlib.f
include ramen/struct.f
include ramen/color.f
include ramen/fixops.f
include afkit/plat/sf/fixedp.f \ must come after fixops.  we need fixed-point literals ... it's unavoidable
include ramen/stack.f
include ramen/rect.f

\ Assets
include ramen/assets.f
include ramen/image.f
include ramen/font.f
include ramen/buffer.f
include ramen/sample.f

\ Higher level facilities
include ramen/obj.f
include ramen/publish.f
\ --------------------------------------------------------------------------------------------------
redef off  \ from here on fields only defined if not previously defined

: resolution  ( w h -- ) 2i resolution ;

: nativewh  native 2@ 2p ;

: displayw  display al_get_display_width 1p ;
: displayh  display al_get_display_height 1p ;
: displaywh  displayw displayh ;

: globalscale  #globalscale 1p ;
: viewwh  desired-res xy@ 2p ;
: vieww  viewwh drop ;
: viewh  viewwh nip ;

: transform:  ( x y sx sy ang -- <name> )
    >r >r >r >r >r
    create here  /transform allot
    r> r> r> r> 4af r> >rad 1af al_build_transform ;

: fps  fps 1p ;

: gscale  globalscale dup 2* ;
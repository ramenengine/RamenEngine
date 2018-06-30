include afkit/ans/version.f
$000102 [version] ramen-ver
\ --------------------------------------------------------------------------------------------------
$000900 include afkit/kit.f
include ramen/plat.f
include afkit/dep/zlib/zlib.f
include ramen/utils.f
include ramen/struct.f
include ramen/fixops.f
include afkit/plat/sf/fixedp.f \ must come after fixops.  we need fixed-point literals ... it's unavoidable

include ramen/assets.f
include ramen/image.f
include ramen/font.f
include ramen/buffer.f
include ramen/sample.f

include ramen/color.f
\ --------------------------------------------------------------------------------------------------
include ramen/obj.f
\ --------------------------------------------------------------------------------------------------
include ramen/cellstack.f
include ramen/publish.f
\ --------------------------------------------------------------------------------------------------
redef off  \ from here on fields only defined if not previously defined

: resolution  2i resolution ;

: displayw  display al_get_display_width 1p ;
: displayh  display al_get_display_height 1p ;
: displaywh  displayw displayh ;

: vieww  displayw #globalscale 1p / ;
: viewh  displayh #globalscale 1p / ;
: viewwh  vieww viewh ;

: transform:  ( x y sx sy ang -- <name> )
    >r >r >r >r >r
    create here  /transform allot
    r> r> r> r> 4af r> >rad 1af al_build_transform ;

: fps  fps 1p ;


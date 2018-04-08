include kit/ans/version.f
$000100 [version] ramen-ver
\ --------------------------------------------------------------------------------------------------
$000600 include kit/kit.f
include ramen/utils.f
include ramen/struct.f
include ramen/fixops.f
include kit/plat/sf/fixedp.f \ must come after fixops.  we need fixed-point literals ... it's unavoidable
include ramen/assets.f
include ramen/image.f
include ramen/color.f
\ --------------------------------------------------------------------------------------------------
include ramen/obj.f
\ --------------------------------------------------------------------------------------------------
include ramen/cellstack.f
include ramen/publish.f
\ --------------------------------------------------------------------------------------------------
redef off  \ from here on fields only defined if not previously defined

: displayw  display al_get_display_width 1p ;
: displayh  display al_get_display_height 1p ;
: displaywh  displayw displayh ;

: vieww  displayw global-scale 1p / ;
: viewh  displayh global-scale 1p / ;
: viewwh  vieww viewh ;

: transform:  ( x y sx sy ang -- <name> )
    >r >r >r >r >r
    create here  /transform allot
    r> r> r> r> 4af r> >rad 1af al_build_transform ;

: fps  fps 1p ;
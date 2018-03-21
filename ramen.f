include kit/ans/version.f
$000100 [version] ramen-ver
\ --------------------------------------------------------------------------------------------------
$000600 include kit/kit.f
include ramen/utils.f
include ramen/struct.f
include ramen/fixops.f
include kit/plat/sf/fixedp.f \ must come after fixops.  we need fixed-point literals ... it's unavoidable
include ramen/image.f
include ramen/color.f
\ --------------------------------------------------------------------------------------------------
include ramen/obj.f
include ramen/node.f
\ --------------------------------------------------------------------------------------------------
redef off  \ from here on fields only defined if not previously defined

include kit/lib/version.f
$000100 [version] ramen-version

$000600 include kit/kit.f
include ramen/utils.f
include ramen/struct.f
include ramen/fixops.f
include kit/lib/sf/fixedp.f \ we need fixed-point literals ... it's unavoidable
include ramen/image.f
include ramen/obj.f

redef on
include ramen/node.f
redef off  \ from here on fields only defined if not previously defined

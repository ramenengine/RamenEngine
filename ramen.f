include afkit/ans/version.f
#1 0 0 [version]
exists ramen [if] \\ [then]
true constant ramen
#1 0 0 include afkit/afkit.f  \ AllegroForthKit
include ramen/base.f

\ Assets
include ramen/assets.f
include ramen/image.f
include ramen/font.f
include ramen/buffer.f
include ramen/sample.f

\ Higher level facilities
include ramen/obj.f
include ramen/publish.f

redef off  \ from here on fields only defined if not previously defined

objlist stage  \ default object list
used @ value baseline
: -stage  stage -objlist ;
: empty  -stage -assets baseline used ! empty ;

include ramen/default.f
only forth definitions marker (empty)
only forth definitions

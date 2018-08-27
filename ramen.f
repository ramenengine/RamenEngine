[undefined] ramen [if] 
true constant ramen
include afkit/ans/version.f
#1 0 0 [version]

\ --------------------------------------------------------------------------------------------------

#1 0 0 include afkit/afkit.f  \ AllegroForthKit

include ramen/variables.f
include ramen/plat.f
include afkit/dep/zlib/zlib.f
include ramen/struct.f
include ramen/color.f
include ramen/fixops.f
include afkit/plat/sf/fixedp.f \ must come after fixops.  we need fixed-point literals ... it's unavoidable
include ramen/stack.f
include ramen/rect.f
include ramen/res.f

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

: frmctr  frmctr 1p ;

:noname
    show>      0e 0e 0.5e 1e 4sf al_clear_to_color
; execute  

only forth definitions marker (empty)
[else]
    drop drop drop 
[then]
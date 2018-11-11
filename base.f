exists ramen [if] \\ [then]
true constant ramen
include afkit/afkit.f  \ AllegroForthKit
#1 #5 #8 [afkit] [checkver]

\ Low-level
0 value (count)
0 value (ts)
0 value (bm)
include ramen/plat.f
[undefined] LIGHTWEIGHT [if]
include afkit/dep/zlib/zlib.f
[then]
include ramen/structs.f
include ramen/fixops.f
include afkit/plat/sf/fixedp.f \ must come after fixops.  we need fixed-point literals ... it's unavoidable
include ramen/stack.f
include ramen/res.f
include ramen/batch.f

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

: frmctr  frmctr 1p ;
objlist stage  \ default object list
used @ value baseline
: -stage  stage -objlist ;

[undefined] LIGHTWEIGHT [if]
    include ramen/default.f
[THEN]

: empty
    cr ." Empty!"
    -stage -assets baseline used ! stop empty ;

create ldr 64 allot
: rld  ldr count included ;
: ld   bl parse ldr place  s" .f" ldr append  rld ;

only forth definitions marker (empty)


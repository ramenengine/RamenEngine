exists ramen [if] \\ [then]
true constant ramen
include afkit/afkit.f  \ AllegroForthKit
#1 #5 #8 [afkit] [checkver]

\ Low-level
0 value (count)
0 value (ts)
0 value (bm)
\ include ramen/plat.f
[undefined] LIGHTWEIGHT [if]
include afkit/dep/zlib/zlib.f
[then]
include ramen/structs.f cr .( Loaded structs lex... ) \ "
include ramen/fixops.f
include afkit/plat/sf/fixedp.f \ must come after fixops.  we need fixed-point literals ... it's unavoidable
include ramen/res.f     cr .( Loaded fixed-point... ) \ "
include venery/venery.f cr .( Loaded Venery... ) \ "

\ Assets
include ramen/assets.f  cr .( Loaded assets framework... ) \ "
include ramen/image.f   cr .( Loaded image module... ) \ "
include ramen/font.f    cr .( Loaded font module... ) \ "
include ramen/buffer.f  cr .( Loaded buffer module... ) \ "
include ramen/sample.f  cr .( Loaded sample module... ) \ "

\ Higher level facilities
include ramen/obj.f     cr .( Loaded objects module... ) \ "
include ramen/publish.f cr .( Loaded publish module... ) \ "
include ramen/draw.f    cr .( Loaded draw module... ) \ "

redef off  \ from here on fields only defined if not previously defined

: frmctr  frmctr 1p ;
objlist stage  \ default object list

used @ value baseline
: -stage  stage vacate ;

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

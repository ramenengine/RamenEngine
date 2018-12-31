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
include ramen/fixops.f
include afkit/plat/sf/fixedp.f   \ must come after fixops.  
include ramen/res.f     cr .( Loaded fixed-point... ) \ "
include venery/venery.f cr .( Loaded Venery... ) \ "
include ramen/structs.f cr .( Loaded structs... ) \ "

: <decimal is> bounds ?do i @ i. cell +loop ;
: <int     is> bounds ?do i @ 1i i. cell +loop ;
: <bin     is> dump ;
: <skip    is> 2drop ." ..." space ;
: <fixed   is> bounds ?do i @ dup if p. else i. then cell +loop ;
: sfield  sfield <fixed ;
: svar    svar   <fixed ;
: create-field  create-field <fixed ;
include ramen/types.f   cr .( Loaded essential datatypes... ) \ "

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
used @ value baseline

[undefined] LIGHTWEIGHT [if]
    include ramen/default.f
[THEN]

: empty
    ." [Empty]" cr
    /stage -assets baseline used !
    s" default-step" evaluate empty
    only forth definitions
;

: gild
    used @ to baseline     
    only forth definitions
    s" marker (empty)" evaluate 
;

create ldr 64 allot
: rld  ldr count included ;
: ld   bl parse s" .f" strjoin 2dup 2>r ['] included catch 2r> ldr place throw ;

gild

exists ramen [if] \\ [then]
true constant ramen
include afkit/afkit.f  \ AllegroForthKit
#1 #5 #8 [afkit] [checkver]

( Low-level )
0 value (count)
0 value (ts)
0 value (bm)
[undefined] LIGHTWEIGHT [if]
    include afkit/dep/zlib/zlib.f
[then]
include ramen/fixops.f
include afkit/plat/sf/fixedp.f   \ must come after fixops.  
include ramen/res.f    
include venery/venery.f
include ramen/structs.f

: ?p.      p. ; \ dup $0000fff and if p. else i. then ;
: <int     is> bounds ?do i @ ." #" i. cell +loop ;
: <bin     is> dump ;
: <skip    is> nip ." ( " cell i/ i. ." )" space ;
: <fixed   is> bounds ?do i @ ?p. cell +loop ;
: sfield  sfield <fixed ;
: svar    svar   <fixed ;
: create-field  create-field <fixed ;

include ramen/types.f    
include ramen/superobj.f 

( Assets )
include ramen/assets.f   
include ramen/image.f    
include ramen/font.f     
include ramen/buffer.f   
include ramen/sample.f   

( Higher level stuff )
create ldr 256 /allot
create project 256 /allot

include ramen/publish.f  
include ramen/draw.f     

include ramen/default.f

: panic ( - ) step> noop ;
: void ( - ) panic show> ramenbg ;

: project:  ( -- <path> )
    bl parse project place  s" /" project append
    project count slashes 2drop ;  

: .project  project count type ;
: rld  ldr count nip -exit ldr count included ;
: ?project  project count nip ?exit  ldr count -filename project place ;

: ld  ( -- <file> )
    bl parse s" .f" strjoin 2>r
        2r@ file-exists not if
            project count 2r> -path strjoin 2>r
        then
        2r@ ['] included catch
        2r@ ldr place
            dup 0= if  ?project  then
            throw 
    2r> 2drop ;

: empty
    page
    cr
    ." [Empty]"
    void
    -assets
    0 to now
    source-id 0> if including -name #1 + slashes project place then  \ swiftforth
    empty
;
: gild
    only forth definitions
    s" marker (empty)" evaluate
    cr ." [Gild] "
;
: now  now 1p ;  \ must go last


gild void
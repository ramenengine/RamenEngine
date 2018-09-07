include afkit/ans/version.f
#1 0 0 [version]   
\ always check the version

\ The following is loaded once per session:
[undefined] ramen [if] 
    true constant ramen
    
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

    : frmctr  frmctr 1p ;

[then]

\ The following needs to be reloaded every time EMPTY is called:

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

objlist stage  \ default object list

\ --------------------------------------------------------------------------------------------------
\ some graphics tools for the default engine state

\ draw a rectangular vertical gradient 
create gv  4 /ALLEGRO_VERTEX * /allot
create gi  0 , #1 , #2 , #3 , 
: v!  ( x y a n ) /ALLEGRO_VERTEX *  + >r  2af  r> 2! ;
: color! ( color a n )  /ALLEGRO_VERTEX *  + >r  4@ 4af  r> ALLEGRO_VERTEX.r 4! ;
: vgradient  ( color1 color2 w h -- )
    at@ 2+ at@ locals| y x y2 x2 c2 c1 |
    x y gv 0 v!   x2 y gv 1 v!  x2 y2 gv 2 v!  x y2 gv 3 v!
    c1 gv 2dup 0 color! 1 color!  c2 gv 2dup 2 color! 3 color!
    gv 0 0 gi #4 ALLEGRO_PRIM_TRIANGLE_FAN al_draw_indexed_prim ;

\ convert lch, hsl, hsv to rgb
\ hue is in degrees
create (fc)  3 cells allot
: !color  >r  (fc) color.r sf@ f>p  (fc) color.g sf@ f>p  (fc) color.b sf@ f>p  r> 3! ;
: lch! ( l c h color -- )  >r  >rad  3af  (fc) dup cell+ dup cell+  al_color_lch_to_rgb  r> !color ;
: hsl! ( h s l color -- )  >r  3af  (fc) dup cell+ dup cell+  al_color_hsl_to_rgb  r> !color ;
: hsv! ( h s v color -- )  >r  3af  (fc) dup cell+ dup cell+  al_color_hsv_to_rgb  r> !color ;    
\ --------------------------------------------------------------------------------------------------

\ default engine state
create (c1)  0.0 , 0 , 0.1 , 1 ,
create (c2)  0.25 , 0.1 , 0.4 , 1 , 
: colorcycle
    0 0.1 frmctr -20 / (c1) lch!
    0.25 0.4 frmctr -20 / (c2) lch!
    (c1) (c2)
;
: ramenbg  0 0 at  colorcycle displaywh vgradient ;

:noname
    show>
        unmount  ramenbg 
        mount    stage each> draw
; execute

: think  stage each> act ;
: physics  stage each>  vx 2@ x 2+! ;

:noname
    step>  think  physics
; execute


only forth definitions marker (empty)

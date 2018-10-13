depend ramen/lib/draw.f
nativewh canvas: canv
: (upscale)  canv >bmp onto>  unmount call  ;
: upscale>  ( -- <code> )  r>  (upscale)  mount  0 0 at  canv >bmp blit ;
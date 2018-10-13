depend ramen/lib/draw.f
nativewh canvas: canv

: (size)  viewwh canv resize-canvas ;
: (upscale)  canv >bmp onto>  black 0 alpha backdrop  unmount call ;
: upscale>  ( -- <code> )  (size)  r>  (upscale)  mount  0 0 at  canv >bmp blit ;
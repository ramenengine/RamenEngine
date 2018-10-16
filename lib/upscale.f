\ fat pixels and subscreens

depend ramen/lib/draw.f
nativewh canvas: canv

: (size)  viewwh canv resize-canvas ;
: (upscale)  canv >bmp onto>  black 0 alpha backdrop unmount call ;
: upscaled  ( xt -- bmp )  >code  (size)  (upscale)  canv >bmp ;
: upscale   ( xt -- )  upscaled mount blit ;
: upscale>  ( -- <code> )  r> code> upscale ;

: subscreen  ( xt w h -- )
    res 2@ 2>r 2i res 2!   upscaled   2r> res 2!  mount blit ;
: subscreen>  ( w h -- )  r> code> -rot subscreen ;

nativewh canvas: canv

: (upscale) canv >bmp onto> unmount call ;
: upscale>  ( -- < code> )  r> (upscale)  mount  canv >bmp blit ;
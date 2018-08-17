nativewh canvas: canv

: (upscale) canv >bmp onto> unmount call ;
: upscale>  ( -- < code> )  r> (upscale)  mount  untinted canv >bmp blit ;
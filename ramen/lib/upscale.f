\ fat pixels and subscreens

depend ramen/draw.f
2048 2048 canvas: canv
create tempres  0 , 0 ,

: (size)  viewwh canv resize-canvas ;
: (upscale)  ( code - ) canv >bmp onto>  black 0 alpha backdrop  unmount  call ;
: upscaled  ( draw-xt - )  >code  (size)  (upscale) ;
: ?blitthen>  ( draw-xt upscale-xt - <cleanup-code> )
    catch dup if  display onto  2d  0 0 at  then
    r> call  mount  canv >bmp blit  throw ;
: upscale>  ( - <code> )  r> code> ['] upscaled ?blitthen> noop ;
: subscreen>  ( w h - )
    res 2@ tempres 2! 
    ( w h ) 2i res 2! 
    r> code> ['] upscaled ?blitthen> tempres 2@ res 2! ;

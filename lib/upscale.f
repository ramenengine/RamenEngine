\ fat pixels and subscreens

depend ramen/draw.f
nativewh canvas: canv
create tempres  0 , 0 ,

: (size)  viewwh canv resize-canvas ;
: (upscale)  ( code - ) canv >bmp onto>  black 0 alpha backdrop  unmount  call ;
: upscaled  ( xt - )  >code  (size)  (upscale) ;
: ?blit>  ( xt xt - ) catch dup if display onto 2d 0 0 at then  r> call  mount canv >bmp blit  throw ;
: upscale   ( xt - )  ['] upscaled ?blit>  noop ;
: upscale>  ( - <code> )  r> code> upscale ;
: subscreen  ( xt w h - ) res 2@ tempres 2! 2i res 2! ['] upscaled ?blit> tempres 2@ res 2! ;
: subscreen>  ( w h - )  r> code> -rot subscreen ;

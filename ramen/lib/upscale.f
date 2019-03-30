\ fat pixels and subscreens

depend ramen/draw.f
2048 2048 canvas: canv
create tempres  0 , 0 ,
variable upscaling


transform: p
: 2d
    p al_identity_transform
    p 0 0 -16384 3af   upscaling @ if viewwh globalscale dup 2* else displaywh then 16384 3af
        al_orthographic_transform
    p al_use_projection_transform    
    ALLEGRO_DEPTH_TEST #0 al_set_render_state
;


: (size)  viewwh canv resize-canvas ;
: (upscale)  ( code - )
    canv >bmp onto>
        black 0 alpha backdrop  unmount
            upscaling on  call  upscaling off ;
: upscaled  ( draw-xt - )  >code  (size)  (upscale) ;

: ?blitthen>  ( draw-xt upscale-xt - <cleanup-code> )
    catch dup if  display onto  2d  0 0 at  upscaling off then
    r> call  mount  canv >bmp blit  throw ;

: upscale>  ( - <code> )
    r> code> ['] upscaled ?blitthen> noop ;

: subscreen>  ( w h - )
    res 2@ tempres 2! 
        ( w h ) 2i res 2! 
        r> code> ['] upscaled ?blitthen>
    tempres 2@ res 2! ;

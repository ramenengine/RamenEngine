\ Basic graphics option

: destxy  penx 2@ [undefined] HD [if] 2pfloor [then] ;

create fore 1e sf, 1e sf, 1e sf, 1e sf, 
: rgb  ( r g b )  3af fore 3! ;
: alpha  ( a )  1af fore 3 cells + ! ;
: rgba   alpha rgb ;

\ Bitmaps, backbuffer
: onto>  ( bmp -- <code> )  r>  al_get_target_bitmap >r  swap onto  call  r> al_set_target_bitmap ;
: movebmp  ( src sx sy w h )  write-src BLEND>  destxy 2af 0 al_draw_bitmap ;
: *bmp   ( w h -- bmp )  2i al_create_bitmap ;
: clearbmp  ( r g b a bmp )  onto>  4af al_clear_to_color ;
: backbuf  display al_get_backbuffer ;
: bmpw  al_get_bitmap_width 1p ;
: bmph  al_get_bitmap_height 1p ;
: bmpwh  dup bmpw swap bmph ;

\ Predefined Colors; stored in fixed-point so you can modify them with `['] <color> >BODY`
: 8>p  s>f 255e f/ f>p ;
: createcolor create rot 8>p , swap 8>p , 8>p , 1 , does> 3@ 3af fore 3! 1 alpha ;

hex
00 00 00 createcolor black 69 71 75 createcolor dgrey
9d 9d 9d createcolor grey cc cc cc createcolor lgrey
ff ff ff createcolor white f8 e0 a0 createcolor beige
e0 68 fb createcolor pink ce 26 33 createcolor red
73 29 30 createcolor dred  eb 89 31 createcolor lbrown
a4 64 22 createcolor brown f7 e2 5b createcolor yellow
bc b3 30 createcolor dyellow ae 3c 27 createcolor lgreen
44 89 1a createcolor green 21 5c 2e createcolor dgreen
27 c1 a7 createcolor cyan 14 80 7e createcolor dcyan
24 5a ef createcolor blue 34 2a 97 createcolor dblue
31 a2 f2 createcolor lblue 93 73 eb createcolor purple
96 4b a8 createcolor dpurple cb 5c cf createcolor magenta
80 00 80 createcolor dmagenta ff ff 80 createcolor lyellow
e0 e0 80 createcolor tan  
da 42 00 createcolor orange
fixed

: backdrop  fore 4@ al_clear_to_color  white ;

\ Bitmap drawing utilities - f stands for flipped
\  All of these words use the current color for tinting.
\  Not all effect combinations are available; these are intended as conveniences.
\  To draw regions of bitmaps, use Allegro's draw bitmap region functions directly
\  or use sub bitmaps (see SUBBMP).
\  The anchor for rotation with CSRBLITF is the center of the passed bitmap.

: blitf  ( bmp flip )  over 0= if  2drop exit  then  >r  destxy 2af  r> al_draw_bitmap ;
: tblitf  ( bmp flip )  over 0= if  2drop exit  then  >r  fore 4@  destxy 2af  r> al_draw_tinted_bitmap ;
: >center  bmpwh 1 rshift  swap 1 rshift ;
: sblitf  ( bmp dw dh flip )
    locals| flip dh dw | ?dup -exit
    ( bmp )  dup >r  0 0 r> bmpwh 4af  destxy dw dh 4af  flip  al_draw_scaled_bitmap ;
: csrblitf ( bmp sx sy ang flip )
    locals| flip ang sy sx bmp |  bmp -exit
    bmp dup >center destxy  4af  sx sy ang 3af  flip
    al_draw_scaled_rotated_bitmap ;
: srblitf ( bmp sx sy ang flip )
    locals| flip ang sy sx bmp |  bmp -exit
    bmp  0 0 destxy  4af  sx sy ang 3af  flip
    al_draw_scaled_rotated_bitmap ;
: blit   ( bmp ) 0 blitf ;
: tblit  ( bmp ) 0 tblitf ;
: blitrgnf  ( bmp x y w h flip )
    locals| flip h w y x bmp |
    bmp  x y w h 4af  destxy 2af  flip  al_draw_bitmap_region ;
: blitrgn  0 blitrgnf ;


\ Text; uses Ramen font assets
variable fnt  default-font fnt !
variable lmargin
: chrw  >fnt z" A" al_get_text_width 1p ;
: chrh  >fnt al_get_font_line_height 1p ;
: strw  zstring fnt @ >fnt swap al_get_text_width 1p ;
: strwh  strw fnt @ chrh ;
: fontw  fnt @ chrw ;
: fonth  fnt @ chrh ;
: (print) ( str count alignment -- )
    -rot  zstring >r  >r  fnt @ >fnt fore 4@ destxy 2af r> r> al_draw_text ;
: print  ALLEGRO_ALIGN_LEFT (print)  ;
: printr  ALLEGRO_ALIGN_RIGHT (print) ;
: printc  ALLEGRO_ALIGN_CENTER (print) ;
: print+  2dup print strw 0 +at ;
: newline  lmargin @ destxy nip fnt @ fonth + at ;

\ Primitives
1e fnegate 1sf constant hairline
: pofs  0.625 0.625 2+ ;
: -pofs  ; \ -0.375 -0.375 2+ ;
: line   destxy pofs  2swap 4af fore 4@ hairline al_draw_line ;
: +line  destxy pofs 2+ line ;
: line+  2dup +line +at ;
: pixel  destxy pofs  2af  fore 4@  al_draw_pixel ;
: rect   ( w h )  destxy pofs  2swap 2over 2+ 4af fore 4@ hairline al_draw_rectangle ;
: rectf  ( w h )  destxy -pofs  2swap 2over 2+ 4af fore 4@ al_draw_filled_rectangle ;
: rrect  ( w h rx ry )  2>r 1 1 2-  destxy pofs 2swap 2over 2+ 4af 2r> 2af fore 4@ hairline al_draw_rounded_rectangle ;
: rrectf  ( w h rx ry )  2>r destxy -pofs 2swap 2over 2+ 4af 2r> 2af fore 4@ al_draw_filled_rounded_rectangle ;
: oval  ( rx ry ) destxy 2swap 4af fore 4@ hairline al_draw_ellipse ;
: ovalf ( rx ry ) destxy 2swap 4af fore 4@ al_draw_filled_ellipse ;
: circ  dup oval ;
: circf  dup ovalf ;


create ftemp  2 cells allot
: 2transform  ( x y transform -- x y )  \ transform coordinates
    >r 2pf 2sf ftemp 2!
    r> ftemp dup cell+ al_transform_coordinates
    ftemp sf@ f>p  ftemp cell+ sf@ f>p ;

: 2screen  ( x y -- x y )  al_get_current_transform 2transform ;  \ convert coordinates into screen space

\ Clipping rectangle
variable cx variable cy variable cw variable ch      \ old clip
variable ccx variable ccy variable ccw variable cch  \ current clip
viewwh ch ! cw !
: clipxy  ccx @ ccy @ ;
: clipwh  ccw @ cch @ ;
0 value (code)

: clip>  ( x y w h -- <code> )  \ note this won't work properly for rotated transforms.
                                \ TODO: implement our own clipping box using the alpha channel or something
    r> to (code)

    
    ccx @ ccy @ ccw @ cch @ 2>r 2>r
    
    2over 2over   cch ! ccw ! ccy ! ccx !
    
    cx cy cw ch al_get_clipping_rectangle
    
    2over 2+
    2screen 2swap 2screen 2swap
    2over 2-
    
    4i al_set_clipping_rectangle   (code) call
    
    cx @ cy @ cw @ ch @ al_set_clipping_rectangle
    
    2r> 2r>  cch ! ccw ! ccy ! ccx ! ;

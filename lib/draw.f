\ Basic graphics option
$000100 [version] draw-ver

create fore 4 cells allot
: fcolored  ( f: r g b a )  4sf fore 4! ;
: colored   ( r g b a )  4af fore 4! ;

\ Bitmaps, backbuffer
: onto  r>  al_get_target_bitmap >r  swap al_set_target_bitmap  call  r> al_set_target_bitmap ;
: movebmp  ( src sx sy w h ) write-rgba blend>  at@ 2af 0 al_draw_bitmap ;
: *bmp   ( w h -- bmp ) 2i al_create_bitmap ;
: clearbmp  ( r g b a bmp )  onto 4af al_clear_to_color ;
: backbuf  display al_get_backbuffer ;

\ Predefined Colors
: 8>p  s>f 255e f/ f>p ;
: createcolor create 8>p swap 8>p rot 8>p , , , 1 .0 ,  does> 4@ colored ;
: (sf+)  dup sf@ f>p swap cell+ ;
: @color  fore (sf+) (sf+) (sf+) (sf+) drop ;

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
e0 e0 80 createcolor tan  f7 b0 80 createcolor caucasian
da 42 00 createcolor orange

: backdrop  fore 4@ al_clear_to_color  white ;

\ Bitmap drawing utilities - f stands for flipped
\  All of these words use the current color for tinting.
\  Not all effect combinations are available; these are intended as conveniences.
\  To draw regions of bitmaps, use Allegro's draw bitmap region functions directly
\  or use sub bitmaps (see SUBBMP).
\  After each call to one of these words, the current color is reset to white.
\  The anchor for rotation is the center of the passed bitmap.

: blitf  ( bmp flip )  over 0= if  2drop exit  then  >r  fore 4@  at@ 2af  r> al_draw_tinted_bitmap  white ;
: >center  bmpwh 1 rshift  swap 1 rshift ;
: sblitf  ( bmp dw dh flip )
    locals| flip dh dw | ?dup ?exit
    ( bmp )  dup >r  fore 4@  0 0 r> bmpwh 4af  at@ dw dh 4af  flip  al_draw_tinted_scaled_bitmap  white ;
: csrblitf ( bmp sx sy ang flip )
    locals| flip ang sy sx bmp |  bmp ?exit
    bmp  fore 4@  bmp >center  at@  4af  sx sy ang 3af  flip  al_draw_tinted_scaled_rotated_bitmap  white ;
: blit   ( bmp ) 0 blitf ;


\ Text
variable fnt  default-font fnt !
variable (x)
: fontw  z" A" al_get_text_width 1p ;
: fonth  al_get_font_line_height 1p ;
: aprint ( str count alignment -- )
    at@ drop (x) !
    -rot zstring >r  >r  fnt @ fore 4@ at@ 2af r> r@ al_draw_text
    fnt @ r> al_get_text_width 1p 0 +at ;
: print  ( str count -- )  ALLEGRO_ALIGN_LEFT aprint ;
: printr  ( str count -- )  ALLEGRO_ALIGN_RIGHT aprint ;
: printc  ( str count -- )  ALLEGRO_ALIGN_CENTER aprint ;
: font>  ( font -- <code> )  fnt !  r> call ;
: newline  (x) @ at@ nip fnt @ fonth + at ;
: textw  zstring fnt @ swap al_get_text_width 1p ;

\ Primitives
1e fnegate 1sf constant hairline
: line   at@ 2swap 4af fore 4@ hairline al_draw_line ;
: +line  at@ 2+ line ;
: line+  2dup +line +at ;
: pixel  at@ 2af  fore 4@  al_draw_pixel ;
: tri  ( x y x y x y ) 2>r 4af 2r> 2af fore 4@ hairline al_draw_triangle ;
: trif  ( x y x y x y ) 2>r 4af 2r> 2af fore 4@ al_draw_filled_triangle ;
: rect   ( w h )  at@ 2swap 2over 2+ 4af fore 4@ hairline al_draw_rectangle ;
: rectf  ( w h )  at@ 2swap 2over 2+ 4af fore 4@ al_draw_filled_rectangle ;
: capsule  ( w h rx ry )  2>r at@ 2swap 2over 2+ 4af 2r> 2af fore 4@ hairline al_draw_rounded_rectangle ;
: capsulef  ( w h rx ry )  2>r at@ 2swap 2over 2+ 4af 2r> 2af fore 4@ al_draw_filled_rounded_rectangle ;
: circle  ( r ) at@ rot 3af fore 4@ hairline al_draw_circle ;
: circlef ( r ) at@ rot 3af fore 4@ al_draw_filled_circle ;
: ellipse  ( rx ry ) at@ 2swap 4af fore 4@ hairline al_draw_ellipse ;
: ellipsef ( rx ry ) at@ 2swap 4af fore 4@ al_draw_filled_ellipse ;
: arc  ( r a1 a2 )  >r at@ 2swap 4af r> 1af fore 4@ hairline al_draw_arc ;


create ftemp  2 cells allot
: 2transform  ( x y transform -- x y )  \ transform coordinates
    >r 2f 2sf ftemp 2!
    r> ftemp dup cell+ al_transform_coordinates
    ftemp sf@ f>p  ftemp cell+ sf@ f>p ;

: 2screen  ( x y -- x y )  al_get_current_transform 2transform ;  \ convert coordinates into screen space

\ Clipping rectangle
variable cx variable cy variable cw variable ch      \ old clip
variable ccx variable ccy variable ccw variable cch  \ current clip
: clipxy  ccx @ ccy @ ;
: clipwh  ccw @ cch @ ;
0 value (code)
: clip>  ( x y w h -- <code> )  \ note this won't work properly for rotated transforms.
                                \ TODO: implement our own clipping box using the alpha channel or something
    r> to (code)
    ccx @ ccy @ ccw @ cch @ 2>r 2>r
    2over 2over cch ! ccw ! ccy ! ccx !
    cx cy cw ch al_get_clipping_rectangle
    2over 2+ 2screen 2swap 2screen 2swap 2over 2-
    4i al_set_clipping_rectangle   (code) call
    cx @ cy @ cw @ ch @ al_set_clipping_rectangle
    2r> 2r>  cch ! ccw ! ccy ! ccx ! ;


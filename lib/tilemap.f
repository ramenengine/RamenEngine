\ Tilemap rendering
\  Loading tiles, tile and tilemap display and collision routines

depend ramen/lib/draw.f
depend ramen/lib/array2d.f

[undefined] #MAXTILES [if] 16384 constant #MAXTILES [then]

create tiles #MAXTILES stack 
0 value tba  \ tileset base address

\ -------------------------------------------------------------------------------------------------
\ Break up a bitmap into tiles

: tilebmp  ( n -- bmp )
    #MAXTILES 1 - and tiles nth @ ;

: maketiles  ( bitmap tilew tileh firstid -- )
    locals| id th tw bmp |
    bmp bmph dup th mod - 0 do
        bmp bmpw dup tw mod - 0 do
            bmp i j 2i tw th 2i al_create_sub_bitmap  tiles id [] !
            1 +to id
        tw +loop
    th +loop
;

: -tiles  ( -- )
    #MAXTILES for  tiles i [] dup @ -bmp  off  loop ;

\ -------------------------------------------------------------------------------------------------
\ Render a tilemap

\  Given a starting address, a pitch, and a tileset base, render tiles to fill the current
\  clip rectangle of the current destination bitmap.

\  The tilemap format is in cells and in the following format:
\  00vh 0000 0000 0000 tttt tttt tttt tt00  ( t=tile # 0-16383, v=vflip, h=hflip)

\  TILEMAP draws within the clip rectangle + (1,1) pixels

\  NOTE: Base tile + 1's width and height defines the "grid dimensions". (0 is nothing and transparent)

\ -------------------------------------------------------------------------------------------------

: tilebase!  ( tile# -- )
    tiles nth to tba ;

0 tilebase!

decimal \ for speed
: tile>bmp  ( tiledata -- bitmap )  $03fff000 and #10 >> tba + @ ;
: tsize  ( tildata -- w h )  tile>bmp bmpwh ;
: draw-bitmap  over 0= if 2drop exit then  >r  at@ 2af  r> al_draw_bitmap ;
: tile  ( tiledat -- )  ?dup -exit  dup tile>bmp swap #28 >> draw-bitmap ;
: tile+  ( stridex stridey tiledat -- )  tile +at ;
fixed

: tilemap  ( addr /pitch -- )
    hold>  1 tsize  clipwh  2over 2/  2 1 2+ locals| rows cols th tw pitch | 
    rows for
        at@  ( addr x y )
            third  cols cells over + swap do
                tw 0 i @ tile+
            cell +loop
        th + at   ( addr )  pitch +
    loop  drop  ;


: scrollofs  ( scrollx scrolly tilew tileh pen=xy -- col row pen=offsetted )
    2over 2over 2mod 2negate +at   2/ 2pfloor ;

\ Isometric support
: >iso  ( x y -- x y )  2dup swap 1 >> - >r + r> ;
: >car  ( x y -- x y )  2dup 2 / swap 2 / + >r - r> ;

: isotilemap  ( addr /pitch cols rows -- )
    hold>  1 tsize locals| th tw rows cols pitch |
    rows for
        at@  ( addr x y )
            third  cols for
                tw th third @ tile+  cell+
            loop  drop
        tw negate th 2+ at   ( addr )  pitch +
    loop  drop  ;


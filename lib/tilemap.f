\ Tilemap rendering
\  Loading tiles, tile and tilemap display and collision routines

    require ramen/lib/draw.f
    require ramen/lib/array2d.f

[undefined] #MAXTILES [if] 16384 constant #MAXTILES [then]

\ note even though we use TRUNCATE and PUSH in this code it's not really a stack.
create tiles #MAXTILES stack 

\ -------------------------------------------------------------------------------------------------
\ Break up a bitmap into tiles

: tilebmp  ( n -- bmp )  #MAXTILES 1 - and tiles nth @ ;

: maketiles  ( bitmap tilew tileh firstid -- )
    locals| id th tw bmp |
    bmp bmph dup th mod - 0 do
        bmp bmpw dup tw mod - 0 do
            bmp i j 2i tw th 2i al_create_sub_bitmap  tiles id [] !
            1 +to id
        tw +loop
    th +loop
;

: -tiles  #MAXTILES for  tiles i [] dup @ -bmp  off  loop ;

\ -------------------------------------------------------------------------------------------------
\ Render a tilemap

\  Given a starting address, a pitch, and a tileset base, render tiles to fill the current
\  clip rectangle of the current destination bitmap.

\  The tilemap format is in cells and in the following format:
\  00vh 0000 0000 0000 tttt tttt tttt tt00  ( t=tile # 0-16383, v=vflip, h=hflip)

\  TILEMAP draws within the clip rectangle + (1,1) pixels

\  NOTE: Base tile + 1's width and height defines the "grid dimensions". (0 is nothing and transparent)

\ -------------------------------------------------------------------------------------------------

0 value tba  \ tileset base address

: tilebase!  ( tile# -- )  tiles nth to tba ;  0 tilebase!

: tsize  tba cell+ @ bmpwh ;

decimal \ for speed
: tile  ( tiledat -- )
    ?dup -exit
    dup >r  $03fff000 and #10 >> tba + @  at@ 2af  r> #28 >>  al_draw_bitmap ;
: tile+  ( stridex stridey tiledat -- )  tile +at ;
fixed

: tilemap  ( addr /pitch -- )
    hold>  tsize  clipwh  2over 2/  2 1 2+ locals| rows cols th tw pitch | 
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
: >iso  2dup swap 1 >> - >r  +  r> ;
: >car  2dup 2 / swap 2 / + >r   -   r> ;

: isotilemap  ( addr /pitch cols rows -- )
    hold>  tsize locals| th tw rows cols pitch |
    rows for
        at@  ( addr x y )
            third  cols for
                tw th third @ tile+  cell+
            loop  drop
        tw negate th 2+ at   ( addr )  pitch +
    loop  drop  ;

( ---=== Tilemap rendering and objects ===--- )
\  Loading tiles, tile and tilemap display, and collision routines

depend ramen/lib/array2d.f
depend ramen/lib/buffer2d.f

[undefined] #MAXTILES [if] 16384 constant #MAXTILES [then]

[undefined] tiles [if]
    create tiles #MAXTILES array, 
    :noname drop  tiles 0array ; +loadtrig 
    0 value tba  \ tileset base address
    512 512 buffer2d: tilebuf 
[then]

extend: _actor
    var scrollx  var scrolly  \ used to define starting column and row!
    var w  var h              \ width & height in pixels
    var tbi                   \ tile base index
;class

\ -------------------------------------------------------------------------------------------------
\ Break up a bitmap into tiles that can be used by the Tiled module

: tilebmp  ( n - bmp )
    #MAXTILES 1 - and tiles [] @ ;

: maketiles  ( bitmap tilew tileh firstid - )
    locals| id th tw bmp |
    bmp bmph dup th mod - 0 do
        bmp bmpw dup tw mod - 0 do
            bmp i j 2i tw th 2i al_create_sub_bitmap  id tiles [] !
            1 +to id
        tw +loop
    th +loop
;

: -tiles  ( - )
    tiles capacity for  i tiles [] dup @ -bmp  off  loop ;

\ -------------------------------------------------------------------------------------------------
\ Render a tilemap

\  Given a starting address, a pitch, and a tileset base, render tiles to fill the current
\  clip rectangle of the current destination bitmap.

\  The tilemap is arranged in 32-bit cells, here's the format:
\  00vh 00tt tttt tttt tttt 0000 0000 0000  ( t=tile # 0-16383, v=vflip, h=hflip)

\  TILEMAP draws within the clip rectangle + (1,1) pixels

\  NOTE: Base tile + 1's width and height defines the "grid dimensions". (0 is nothing and transparent)

\ -------------------------------------------------------------------------------------------------

: tilebase!  ( tile# - )
    tiles [] to tba ;

0 tilebase!

: >gid  ( tile - gid )
    $03fff000 and ;

decimal \ for speed
: tile>bmp  ( tiledata - bitmap )  $03fff000 and #10 >> tba + @ ;
: tilesize  ( tiledata - w h )  tile>bmp bmpwh ;
: draw-bitmap  over 0= if 2drop exit then  >r  at@ 2af  r> al_draw_bitmap ;
: tile  ( tiledat - )  ?dup -exit  dup tile>bmp swap #28 >> draw-bitmap ;
fixed

create tstep 16 , 16 ,
: tstep@  tstep 2@ ;

: tilemap  ( addr /pitch - )
    hold>  tstep@  clipwh  2over 2/ 2 1 2+  locals| rows cols th tw pitch | 
    rows for
        at@  ( addr x y )
            third  cols cells over + swap do
                i @ tile tw 0 +at
            cell +loop
        th + at   ( addr )  pitch +
    loop  drop  ;


: scrollofs  ( scrollx scrolly tilew tileh pen=xy - col row pen=offsetted )
    [undefined] hd [if] 2swap 2pfloor 2swap [then]
    2over 2over 2mod 2negate +at   2/ 2pfloor ;

\ Isometric support
: >iso  ( x y - x y )  2dup swap 1 >> - >r + r> ;
: >car  ( x y - x y )  2dup 2 / swap 2 / + >r - r> ;

: isotilemap  ( addr /pitch cols rows - )
    hold>  tstep@  locals| th tw rows cols pitch |
    rows for
        at@  ( addr x y )
            third  cols for
                dup @ tile  cell+  tw th +at
            loop  drop
        tw negate th 2+ at   ( addr )  pitch +
    loop  drop  ;


( ---=== Tilemap objects ===--- )
\ They don't allocate any buffers for map data.
\ A part of the singular buffer TILEBUF is located using the scrollx/scrolly values.

: /tilemap  ( - )
    viewwh w 2!
    draw>
        tbi @ tilebase!
        at@ w 2@ clip>
            scrollx 2@  tstep@ scrollofs  tilebuf loc  tilebuf pitch@  tilemap ;

: /isotilemap  ( - )
    draw>
        tbi @ tilebase!
        scrollx 2@  tstep@ scrollofs  tilebuf loc  tilebuf pitch@  50 50 isotilemap ;

\ Tilemap collision
include ramen/lib/std/collision.f

( ---=== Tilemap rendering and objects ===--- )

depend ramen/lib/array2d.f
depend ramen/lib/buffer2d.f

512 512 buffer2d: tilebuf
8 stack: tilebanks

\ note that these can be resized and re-subdivided to whatever dimensions you want at any time.
256 1024 canvas: tilebank0   tilebank0 tilebanks push   16 16 tilebank0 subdivide
256 1024 canvas: tilebank1   tilebank1 tilebanks push   16 16 tilebank1 subdivide
256 1024 canvas: tilebank2   tilebank2 tilebanks push   16 16 tilebank2 subdivide
256 1024 canvas: tilebank3   tilebank3 tilebanks push   16 16 tilebank3 subdivide
256 1024 canvas: tilebank4   tilebank4 tilebanks push   16 16 tilebank4 subdivide
256 1024 canvas: tilebank5   tilebank5 tilebanks push   16 16 tilebank5 subdivide
256 1024 canvas: tilebank6   tilebank6 tilebanks push   16 16 tilebank6 subdivide
256 1024 canvas: tilebank7   tilebank7 tilebanks push   16 16 tilebank7 subdivide

0 value tb

: tilebank  ( n - )
    7 and tilebanks [] @ to tb ;  0 tilebank

: puttiles ( bitmap -- )  \ rect is in SRCRECT, dest x,y in pen, dest bank is specified with TILEBANK
    tb >bmp onto> srcrect xywh@ movebmp ;

: entire ( bitmap - )
    0 0 rot bmpwh srcrect xywh! ;

: (loadtiles)  ( bitmap )
    dup entire dup puttiles -bmp ;    

: loadtiles  ( path count -- )  \ dest x,y in pen, dest bank is specified with TILEBANK
    loadbmp (loadtiles) ;

: dimbank  ( tilew tileh bankw bankh -- )
    tb resize-canvas tb subdivide ;

: loadtileset  ( path count tilew tileh -- )
    2>r   0 0 at  loadbmp 2r> third bmpwh dimbank  (loadtiles) ;


\ -------------------------------------------------------------------------------------------------
\ Render a tilemap

\  Given a starting address, a pitch, and a tileset base, render tiles to fill the current
\  clip rectangle of the current destination bitmap.

\  The tilemap is arranged in 32-bit cells, here's the format:
\  00vh 00tt tttt tttt tttt 0000 0000 0000  ( t=tile # 0-16383, v=vflip, h=hflip)

\  TILEMAP draws within the current clipping rectangle.

\ -------------------------------------------------------------------------------------------------


decimal \ for speed

    : tile>rgn  ( tiledata - bitmap x y w h )
        tb >bmp swap $003ff000 and 1.0 - tb subxywh ;
    
    : draw-region  ( bitmap x y w h flip - )
        >r  4af  at@ 2af  r> al_draw_bitmap_region ;
        
    : tile  ( tiledat - )
        ?dup -exit  dup >r  tile>rgn  r> #28 >> draw-region ;
        
fixed


: tstep@  ( - w h )
    tb image.subw 2@ ;

: draw-tilemap  ( addr /pitch - )
    hold>  tstep@  clipwh  2over 2/ 2 1 2+  locals| rows cols th tw pitch | 
    rows for
        at@  ( addr x y )
            third  cols cells over + swap do
                i @ tile tw 0 +at
            cell +loop
        th + at   ( addr )  pitch +
    loop  drop  ;


: scrollofs  ( scrollx scrolly tilew tileh pen=xy - col row pen=offsetted )
    [undefined] HD [if] 2swap 2pfloor 2swap [then]
    2over 2over 2mod 2negate +at   2/ 2pfloor ;

\ Isometric support
: >iso  ( x y - x y )  2dup swap 1 >> - >r + r> ;
: >car  ( x y - x y )  2dup 2 / swap 2 / + >r - r> ;

: draw-isotilemap  ( addr /pitch cols rows - )
    hold>  tstep@  locals| th tw rows cols pitch |
    rows for
        at@  ( addr x y )
            third  cols for
                dup @ tile  cell+   tw th +at
            loop  drop
        tw negate th 2+ at   ( addr )  pitch +
    loop  drop  ;


( ---=== Tilemap objects ===--- )
\ They don't allocate any buffers for map data.
\ A part of the singular buffer TILEBUF is located using the scrollx/scrolly values.


extend: _actor
    var scrollx  var scrolly  \ used to define starting column and row!
    var w  var h              \ width & height in pixels (or tiles in the case of isometric...)
    var tbi                   \ tilebank index
;class

: tilemap  ( - )
    tbi @ tilebank
    at@ w 2@ clip>
        scrollx 2@ 0 0 2max scrollx 2!
        scrollx 2@  tstep@ scrollofs  tilebuf loc  tilebuf pitch@  draw-tilemap ;

: /tilemap  ( - )
    viewwh w 2!
    draw> tilemap ;

\ : /isotilemap  ( cols rows - )
\     w 2!
\     draw>
\         scrollx 2@ 0 0 2max scrollx 2!
\         tbi @ tilebank
\         scrollx 2@ tilebuf loc  tilebuf pitch@  w 2@ isotilemap ;

\ Tilemap collision
include ramen/lib/std/collision.f

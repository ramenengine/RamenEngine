\ Global tileset system
\  Loading tiles, tile and tilemap display and collision routines
\  Maximum 4096 tiles.

4096 dup constant maxtiles
    cellstack: tiles

: tile>sb  ( n -- subbmp )
    maxtiles 1 - and tiles nth @ ;

: add-tiles ( image tilew tileh -- firstn )
    third subdivide
    tiles #pushed swap  dup subcount @ 0 do  i over imgsubbmp  tiles push  loop  drop ;

: set-tiles  ( image tilew tileh n -- )
    tiles #pushed >r  tiles swap truncate  add-tiles  drop
    tiles #pushed r> max tiles swap truncate ;

: clear-tiles  ( -- )
    0 tiles nth a!>  maxtiles 0 do  @+ -bmp  loop  tiles 0 truncate ;


\ Render a tilemap

\  Given a starting address, a pitch, and a tile base, render tiles to fill the current
\  clip rectangle of the current destination bitmap.

\  The tilemap format is in cells and in the following format:
\  00vh 0000 0000 0000 tttt tttt tttt tt00  ( t=tile # 0-16383, v=vflip, h=hflip)

\  DRAW-TILEMAP draws within the clip rectangle + (1,1) pixels

\  NOTE: Base tile + 1's width and height defines the "grid dimensions". (0 is nothing and transparent)


0 value tba  \ tile base address

: tilebase!  ( tile# -- )  cells tiles + to tba ;
0 tilebase!

: tsize  tba cell+ @ bmpwh ;

: tile  ( width index -- )  \ NOT A GID
    ?dup if  dup $0000fffc and tba + @  swap 28 >>  blitf  then  0 +at ;

: draw-tilemap  ( addr /pitch -- )
    tsize  clipwh 1 1 2+  2over 2/  locals| rows cols th tw pitch |
    rows for
        at@  ( addr x y )
            third  cols for
                tw over @ tile  cell+
            loop  drop
        th + at   ( addr )  pitch +
    loop  drop  ;

: scroll  ( scrollx scrolly tilew tileh pen=xy -- col row pen=offsetted )
    2over 2over 2mod 2negate +at   2/ 2pfloor ;

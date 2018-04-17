\ Global tileset system
\  Loading tiles, tile and tilemap display and collision routines
\  Maximum 16384 tiles.

16384 dup constant maxtiles  cellstack tiles
: tile  maxtiles 1 - and tiles [] @ ;
: !tiles  tiles #pushed swap  dup subcount @ 0 do  i over imgsubbmp  tiles push  loop  drop ;
: addtiles ( image tilew tileh -- firstn ) third subdivide  !tiles ;
: changetiles  ( image tilew tileh n -- )  tiles #pushed >r  tiles swap truncate  add-tiles  drop
    tiles #pushed r> max tiles swap truncate ;
: cleartiles  ( -- )  0 tiles [] a!>  maxtiles 0 do  @+ -bmp  loop  tiles 0 truncate ;


\ Render a tilemap
\  Given a starting address, a pitch, and a tile base, render tiles to fill the current
\  clip rectangle of the current destination bitmap.
\  The tilemap format is in cells and in the following format:
\  00vh 0000 0000 0000 tttt tttt tttt tt00  ( t=tile # 0-16383, v=vflip, h=hflip)
\  DRAWTILEMAP draws within the clip rectangle
\  DRAWTILEMAPBG draws within the clip rectangle plus 1 tile in both directions, enabling scrolling
\  NOTE: Base tile + 1's width and height defines the "grid dimensions". (0 is nothing and transparent)


0 value tba  \ tile base address
: tilebase!  ( tile# -- )  cells tiles + to tba ;
0 tilebase!

: tbwh  tba cell+ @ bmpwh ;

: tile  ?dup if  dup $0000fffc and tba + @  swap 28 >>  blitf  then  0 +at ;

: drawtilemappart  ( addr /pitch cols rows -- )
    tbwh locals| th tw rows cols pitch |
    rows for
        at@  ( addr x y )
        third  cols 0 do  tw over @ tile  cell+  loop  drop
        th + at   pitch +
    loop  drop  ;

: drawtilemap  ( addr /pitch -- )
    clipwh  ( unscaled )  tbwh 2/  drawtilemappart ;

: drawtilemapbg  ( addr /pitch -- )
    clipwh  ( unscaled )  tbwh 2/  1 1 2+  drawtilemappart ;

: scroll  ( scrollx scrolly tilew tileh pen=xy -- col row pen=offsetted )
    2over 2over 2mod 2negate +at   2/ 2pfloor ;

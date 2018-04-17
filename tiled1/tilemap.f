
var scrollx var scrolly
\ var wrap        \ wraparound enable
var w var h   \ map width & height; either scroll will be clipped unless WRAP is on

2048 2048 array2d tilebuf

: tilemap
    displaywh mw 2!
    draw>
        at@ w 2@ scaled clip>
        scrollx 2@ 20 20 scroll tilebuf loc2d  tilebuf @pitch  draw-tilemap-bg ;

: @tile  ( col row -- tile )  tilebuf loc2d @ ;
: >gid  ( tile -- gid )  $0000fffc and 10 << ;

\ Very ghetto
: scroll-tilemap   ( x y tilemap -- )  's scrollx 2! ;

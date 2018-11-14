\ `write2d` ( src-addr pitch destcol destrow #cols #rows dest - ) 
\ `move2d` ( srcrow srccol destcol destrow #cols #rows src - )  
\ `scan2d` ( ... array2d xt - ... ) ( ... addr #cells - ... )
\ `scan2d>` ( array2d - <code> ) ( addr #cells - )
: write2d  ( src-addr pitch destcol destrow #cols #rows dest - )
    locals| dest |
    dest (clip)  2swap dest addr-pitch  2swap  swap cells 2move ;
: move2d  ( srcrow srccol destcol destrow #cols #rows src - )
    locals| src |
    2>r 2>r  src addr-pitch  2r> 2r> write2d ;
: scan2d  ( ... array2d xt - ... )  ( ... addr #cells - ... )
  >r >r  0  0  r@ dims@  r> r> some2d ;
: scan2d>  r> code> scan2d ;


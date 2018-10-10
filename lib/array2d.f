fixed

: 2move  ( src /pitch dest /pitch #rows /bytes -- )
  locals| #bytes #rows destpitch dest srcpitch src |
  #rows for
    src dest #bytes move
    srcpitch +to src  destpitch +to dest
  loop ;

: clip  ( col row #cols #rows #destcols #destrows -- col row #cols #rows )
    2>r  2over 2+  0 0 2r@ 2clamp  2swap  0 0 2r> 2clamp  2swap 2over 2- ;

struct %array2d
    %array2d int svar array2d.cols
    %array2d int svar array2d.rows
    %array2d int svar array2d.pitch
    %array2d int svar array2d.data
    
: array2d-head,  ( cols rows -- )
    udup  2pfloor 2,  cells ,  here cell+ , ;

decimal
\ by default the data field is set to the adjacent dictionary space
: array2d  ( numcols numrows -- )
    2dup  array2d-head,  2i * cells /allot ;

: count2d ( array2d -- data #cells )
    dup array2d.data @ swap array2d.cols 2@ 2i * ;
fixed

: dims@  ( array2d -- numcols numrows )
    array2d.cols 2@ ;

: (clamp)  ( col row array2d -- col row array2d  )
    >r  2pfloor  0 0 r@ array2d.cols 2@ 2clamp  r> ;

\ TODO: this is incomplete!
\      if dest col/row are negative, we need to adjust the source start address!!

: (clip)   ( col row #cols #rows array2d -- col row #cols #rows array2d  )
    dims@ 1 1 2- clip ;

: loc  ( col row array2d -- addr )
    (clamp) >r  r@ array2d.pitch @ * swap cells +  r> array2d.data @ + ;

: pitch@  ( array2d -- pitch )  array2d.pitch @ ;

\ itteration
: addr-pitch  ( col row array2d -- addr /pitch )
    dup >r loc r> array2d.pitch @ ;

: some2d  ( ... col row #cols #rows array2d XT -- ... )  ( ... addr #cells -- ... )
    >r >r  r@ (clip)   2swap r> addr-pitch
    r> locals| xt pitch src #rows #cols |
    #rows 0 do  src #cols xt execute  pitch +to src  loop ;
    
: some2d>  r> code> some2d ;

:noname  third ifill ;
: fill2d  ( val col row #cols #rows array2d -- )  literal some2d  drop ;

:noname  cr  cells bounds do  i @ h.  cell +loop ;
: 2d.  >r 0 0 r@ dims@ 16 16 2min  r> literal some2d  ;


\ TABLE2D: ( cols -- <name> array2d adr ) 
\ TABLE2D  ( cols -- array2d array2d adr )  the table will be left on the stack after ;TABLE2D
\ ;TABLE2D ( array2d adr -- ) call to terminate the definition

: table2d   here swap 0 array2d-head, dup here ;
: table2d:  create table2d nip ;
: ;table2d  here swap - cell/ over array2d.cols @ / pceil swap array2d.rows ! ;

\ test
marker dispose
create a  10 15 array2d
create b  12 7 array2d
a count2d 5 ifill
b count2d 10 ifill
dispose

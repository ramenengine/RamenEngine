fixed
struct %array2d
    %array2d svar array2d.cols
    %array2d svar array2d.rows
    %array2d svar array2d.pitch
    %array2d svar array2d.data
    %array2d svar array2d.ref    \ another array2d
    %array2d svar array2d.col    \ coords in the referenced array2d
    %array2d svar array2d.row
    
: 2move  ( src /pitch dest /pitch /bytes #rows - )
  locals| #rows #bytes destpitch dest srcpitch src |
  #rows for
    src dest #bytes move
    srcpitch +to src  destpitch +to dest
  loop ;

\ incomplete ... need to adjust address for negative clip
: clip  ( col row #cols #rows #destcols #destrows - col row #cols #rows )
    2>r  2over 2+  0 0 2r@ 2clamp  2swap  0 0 2r> 2clamp  2swap 2over 2- ;
    
: array2d-head,  ( cols rows - )
    udup  2pfloor 2,  cells ( pitch ) ,  here 4 cells + ,
    0 , 0 , 0 , ;

\ by default the data field is set to the adjacent dictionary space
: array2d,  ( numcols numrows - )
    2dup  array2d-head,  * cells /allot ;

: array2d:  ( numcols numrows - <name> )
    create array2d, ;

: count2d ( array2d - data #cells )
    dup array2d.data @ swap array2d.cols 2@ * ;

: dims  ( array2d - numcols numrows )
    array2d.cols 2@ ;

: cols dims drop ;
: rows dims nip ;


: (clamp)  ( col row array2d - col row array2d  )
    >r  2pfloor  0 0 r@ array2d.cols 2@ 2clamp  r> ;

: loc  ( col row array2d - adr )
    (clamp) >r  r@ array2d.pitch @ * swap cells +  r> array2d.data @ + ;

: /section2d  ( section2d - )
    locals| a |
    a array2d.col 2@ a array2d.ref @ loc a array2d.data !
    a array2d.ref @ array2d.pitch @ a array2d.pitch ! ;

: (section2d)  ( loadtrig - )
    loadtrig-size + @ /section2d ;

: section2d:  ( array2d col row #cols #rows - <name> )
    ['] (section2d) +loadtrig  here 0 , 
    create here swap !  array2d-head,  lastbody array2d.ref 3!
    lastbody /section2d ; 

: pitch@  ( array2d - pitch )
    array2d.pitch @ ;

: adr-pitch  ( col row array2d - adr /pitch )
    dup >r loc r> pitch@ ;

: each2d  ( ... col row #cols #rows XT array2d - ... )  ( ... adr #cells - ... )
    swap  >r >r  r@ dims clip   2swap r> adr-pitch
    r>  locals| xt pitch src #rows #cols |
    #rows 0 do  src #cols xt execute  pitch +to src  loop ;
    
: each2d>  r> code> each2d ;

:noname  third ifill ;
: fill2d  ( val col row #cols #rows array2d - )  literal each2d  drop ;

: clear2d  >r 0 0 0 r@ dims r> fill2d ;

:noname  cr  cells bounds do  i @ h.  cell +loop ;
: 2d.  >r 0 0 r@ dims 16 16 2min  r> literal each2d  ;

: put2d  ( src-array2d dest-array2d col row - )  \ no clipping
    rot adr-pitch 2>r
    srcrect xy@ rot adr-pitch 2r> ( adr pitch adr pitch )
    srcrect wh@ >r cells r> 2move ;


\ TABLE2D: ( cols - <name> array2d adr ) 
\ TABLE2D  ( cols - array2d array2d adr )  the table will be left on the stack after ;TABLE2D
\ ;TABLE2D ( array2d adr - ) call to terminate the definition

: table2d   here swap 0 array2d-head, dup here ;
: table2d:  create table2d nip ;
: ;table2d  here swap - cell/ over array2d.cols @ / pceil swap array2d.rows ! ;

\ test
marker dispose
create a  10 15 array2d,
create b  12 7 array2d,
a count2d 5 ifill
b count2d 10 ifill
dispose

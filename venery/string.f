
( String )
struct %string
    %string %collection sembed string.collection
    %string svar string.data

collection-vtable-size vtable string-vtable  ( collection 0 )
    \ []  ( index collection -- adr )
    :vector  array.data @ swap bytes + ; 
    \ truncate  ( n collection -- )
    :vector  collection.length dup @ rot min swap ! ;
    \ push  ( val collection -- )
    :vector  >r  r@ length  r@ [] c!  1 r> collection.length +! ;
    \ pop  ( collection -- val )
    :vector  >r  r@ length 1 -  r@ [] c@   -1 r> collection.length +! ;
    \ each  ( xt collection -- )  ( val -- )
    :vector  xt >r swap to xt dup string.data @ swap length bounds ?do
        i c@ xt execute 1 bytes +loop r> to xt ; 
    \ deletes  ( index count collection -- )
    :vector  3dup nip length >= if 3drop exit then
        locals| c n i |
        i n + c length min i - to n  \ adjust count if needed
        i bytes c string.data @ +  \ dest
        dup n bytes +  \ src
        swap  \ src dest
        c string.data @ c length bytes + \ end
        over - ?move
        n negate c collection.length +! ;
    \ .each  ( collection -- )
    :vector  dup string.data @ swap length dup 1i i.  ." : "  type ;
    \ remove   ( val collection -- )  \ remove all instances
    :vector  locals| c itm |
        c length 0 ?do
            i c length >= if unloop exit then
            i c [] c@ itm = if i 1 c deletes then 
        loop ;
    \ ?@   ( adr collection -- val )  \ adr is val adr, or node, depending, e.g. in EACH SOME DIFF
    :vector  drop c@ ;
    \ removeat            ( i collection -- )  \ deletes or removes the value at i, depending.
    :vector  1 swap deletes ;
    \ insert             ( val i dest-collection -- )
    :vector  locals| dest i val |
        dest 1 more? abort" Error in INSERT: Destination collection is full."
        dest string.data @ i bytes + dup 1 bytes + dest length i - bytes move
        val i dest [] c! 
        1 dest collection.length +! ;
2drop


: *empty-string  ( n -- string )
    %string *struct >r
    string-vtable r@ collection.vtable !
    here r@ string.data !
    dup /allot
    r@ collection.capacity ! 
    r> ;

: set-string  ( adr n string - )
    >r
    2dup r@ string.data @ swap move
    nip
    r> collection.length !
;

: *string  ( adr length capacity -- string )  \ data will be copied from adr
    *empty-string >r
    r@ set-string
    r> ;
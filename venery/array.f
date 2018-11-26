
( Array )
struct %array
    %array %collection sembed array.collection
    %array svar array.data

collection-vtable-size vtable array-vtable  ( collection 0 )
    \ []  ( index collection -- adr )
    :vector  array.data @ swap cells + ; 
    \ truncate  ( n collection -- )
    :vector  collection.length dup @ rot min swap ! ;
    \ push  ( val collection -- )
    :vector  >r  r@ length  r@ [] !  1 r> collection.length +! ;
    \ pop  ( collection -- val )
    :vector  >r  r@ length 1 -  r@ [] @   -1 r> collection.length +! ;
    \ each  ( xt collection -- )  ( val -- )
    :vector  xt >r swap to xt dup array.data @ swap length cells bounds ?do
        i @ xt execute cell +loop r> to xt ; 
    \ deletes  ( index count collection -- )
    :vector  3dup nip length >= if 3drop exit then
        locals| c n i |
        i n + c length min i - to n  \ adjust count if needed
        i cells c array.data @ +  \ dest
        dup n cells +  \ src
        swap  \ src dest
        c array.data @ c length cells + \ end
        over - ?move
        n negate c collection.length +! ;
    \ .each  ( collection -- )
    :vector  dup length . ." items: " each> . ;
    \ remove   ( val collection -- )  \ remove all instances
    :vector  locals| c itm |
        c length 0 ?do
            i c length >= if unloop exit then
            i c [] @ itm = if i 1 c deletes then 
        loop ;
    \ ?@   ( adr collection -- val )  \ adr is val adr, or node, depending, e.g. in EACH SOME DIFF
    :vector  drop @ ;    
    \ removeat            ( i collection -- )  \ deletes or removes the value at i, depending.
    :vector  1 swap deletes ;
    \ insert             ( val i dest-collection -- )
    :vector  locals| dest i val |
        dest 1 more? abort" Error in INSERT: Destination collection is full."
        dest array.data @ i cells + dup cell+ dest length i - cells move
        val i dest [] ! 
        1 dest collection.length +! ;
2drop

: *array  ( n -- array )  %array *struct >r array-vtable r@ collection.vtable !
    here r@ array.data !  dup r@ collection.length !  dup r@
    collection.capacity !  cells /allot  r> ;
: *stack  ( n -- array )  %array *struct >r array-vtable r@ collection.vtable !
    here r@ array.data !  0 r@ collection.length !  dup r@
    collection.capacity !  cells /allot  r> ;

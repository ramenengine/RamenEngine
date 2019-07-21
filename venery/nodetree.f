( Node tree )
struct %node
    %node %collection sembed node.collection
    %node svar node.parent
    %node svar node.previous
    %node svar node.next
    %node svar node.first
    %node svar node.last

collection-vtable-size vtable node-vtable  ( collection 0 )
    \ []  ( index node -- node|0 )
    :vector
        dup length 0 = if 2drop 0 exit then 
        node.first @ swap 0 ?do node.next @ loop ; 
    \ truncate  ( newlength node -- )
    :vector
        locals| c newlen |
        newlen c length over - c deletes 
        newlen c collection.length dup @ rot min swap ! ;
    \ push  ( node destnode -- )
    :vector
        locals| b a |
        a node.parent @ ?dup if a swap remove then
        b node.last @ a node.previous !
        b node.first @ 0 = if  a b node.first !  then
        a b node.last !
        a node.previous @ ?dup if a swap node.next ! then
        b a node.parent !
        1 b collection.length +!
        ;
    \ pop  ( node -- node|0 )
    :vector
        locals| a |
        a node.last @ dup 0 = abort" Tried to pop from empty node"
            dup a remove ;
    \ each  ( xt collection -- )  ( val -- )
    :vector
        dup length 0 = over 0 = or if 2drop exit then 
        xt >r  swap to xt         
        node.first @ begin ?dup while
            dup node.next @ >r
                xt execute
            r>
        repeat 
        r> to xt ; 
    \ deletes  ( index count collection -- )
    :vector  3dup nip length >= if 3drop exit then
        locals| c n i0 |
        n 0 do
            i0 c []  dup c remove free-node
        loop
        ;
    \ .each  ( collection -- )
    :vector  locals| c |  c length dup 1i i.  ." items: "  0 ?do i c [] . loop ;
    \ remove   ( node collection -- )  
    :vector  locals| c n |
        n 0 = if exit then
        n node.parent @ 0 = if exit then  \ not already in any container
        n node.parent @ c = not if abort" Tried to remove node from an unrelated node" then
        -1 c collection.length +!
        c length if
          n c node.first @ = if  n node.next @ c node.first !  then
          n c node.last @ =  if  n node.previous @ c node.last !  then
        else
          0 c node.first !  0 c node.last !
        then
        0 n node.parent ! 
        n node.previous @ if  n node.next @  n node.previous @ node.next !  then
        n node.next @ if  n node.previous @  n node.next @ node.previous !  then
        0 n node.previous !  0 n node.next ! ;  
    \ ?@   ( adr collection -- val )  \ adr is val adr, or node, depending, e.g. in EACH SOME DIFF
    :vector  drop ;
    \ removeat            ( i collection -- )  \ deletes or removes the value at i, depending.
    :vector  dup >r [] r> remove ;
    \ insert             ( node i dest-collection -- )
    :vector  2dup [] locals| sibling b i a |
        a node.parent @ ?dup if a swap remove then
        i b length 1 - >= if
            a b push
            exit
        then
        i 0 = if
            b node.first @ a node.next !
            a b node.first !
            a dup node.next @ node.previous !
        else
            sibling a node.next !
            sibling node.previous @ a node.previous !
            a sibling node.previous !
            a dup node.previous @ node.next !
        then
        b a node.parent !
        1 b collection.length +! ;
2drop

: /node  ( node -- )
    100000 over collection.capacity !
    node-vtable swap collection.vtable ! ;

: 0node  ( node -- )
    dup %node venery:sizeof erase /node ;

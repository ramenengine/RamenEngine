only forth definitions

\ test
create s 100 *stack drop
: numbers  locals| c |  c vacate  c capacity 0 do  i c push  loop ;
s numbers

:noname  %node venery:sizeof allocate throw dup /node ; is new-node
:noname  free throw ; is free-node

new-node constant p
new-node constant n1  n1 p push
new-node constant n2  n2 p push
new-node constant n3  n3 p push
new-node constant n4  n4 p push
new-node constant p2
new-node constant n5  n5 p2 push
new-node constant n6  n6 p2 push
new-node constant n7  n7 p2 push
new-node constant n8  n8 p2 push

only forth definitions

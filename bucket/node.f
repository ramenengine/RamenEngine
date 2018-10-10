redef on
    xvar parent  xvar prev  xvar next   \ node
    xvar length  xvar first  xvar tail  \ container
redef off

: (unlink)  ( node -- )
  dup prev @ if  dup next @  over prev @ next !  then
  dup next @ if  dup prev @  over next @ prev !  then
  dup prev off  next off ;

: removenode  ( node -- )
  ?dup -exit
  dup parent @ 0= if  drop exit  then  \ not already in any container
  dup parent @ >r
  -1 r@ length +!
  r@ length @ if
    dup r@ first @ = if  dup next @  r@ first !  then
    dup r@ tail @ =  if  dup prev @  r@ tail !  then
  else
    r@ first off  r@ tail off
  then
  r> ( container ) drop  ( node ) dup parent off  (unlink) ;

: pushnode  ( node container -- )
  dup 0= if  2drop exit  then
  over parent @ if
    over parent @ over = if  2drop exit  then  \ already in given container
    over removenode  \ if already in another container, remove it first
  then
  ( node container ) >r
  r@ over parent !
  1 r@ length +!
  r@ length @ 1 = if
    dup r@ first !
  else
    r@ tail @
    over prev !  dup r@ tail @ next !
  then
  r> tail ! ;


0 value cxt
0 value c
: thru>  ( ... client-xt first-item -- <advance-code> ... )  ( ... item -- ... next-item|0 )  ( ... item -- ... )
  r>  cxt >r  c >r   to c  swap to cxt
  begin  dup while  dup c call >r  cxt execute  r> repeat
  drop
  r> to c  r> to cxt ;

: itterate  ( ... xt container -- ... )   ( ... obj -- ... )
  dup length @ 0= if 2drop exit then
  first @  thru>  next @ ;
: <itterate  ( ... xt container -- ... )   ( ... obj -- ... )
  dup length @ 0= if 2drop exit then
  tail @  thru>  prev @ ;

:noname  ( container node -- list )  over swap parent ! ; ( xt )

: graft  ( container1 container2 -- )  \ move the contents of container2 to container1
  locals| b a |
  b length @  ?dup -exit  a length +!  b length off
  a tail @ b first @ prev !
  a tail @ if    b first @ a tail @ next !
           else  b first @ a first !
           then
  b tail @ a tail !
  b first off  b tail off
  a ( xt ) LITERAL over itterate drop  \ change the parent of each one
  ;

: popnode  tail @ dup removenode ;


\ --- test ---
marker dispose
create a object
create b object
create c object
create l object

a l pushnode
b l pushnode
c l pushnode
: test   <> abort" container test failed" ;

l length @ 3 test
l popnode c test
  l length @ 2 test
    l tail @ b test
l popnode b test
  l length @ 1 test
    l tail @ a test

l popnode a test
  l length @ 0 test
    l tail @ 0 test

cr .( :::NODE TESTS PASSED::: )
dispose


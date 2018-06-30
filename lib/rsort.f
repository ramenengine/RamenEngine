
\ 16-bit positive-integer-fixed-point-identifier optimized radix sort!
\ supports sorting a range of numbers between and including 0 ~ 65535

\ the "radix" in a radix sort is a position or digit within the numbers
\ we're sorting.  with each pass, we move the radix one digit.  in this case,
\ we start at the right and move to the left until we reach the most significant
\ digit.  after all passes are complete, the list is magically sorted.

\ a radix sort involves no comparisons, but requires a large amount of memory.
\ to control memory use we limit the range of values that this routine
\ can recognize.

\ for this routine to require just 4 passes, we do it by nybbles,
\ which requires 16 buckets * 2.  each bucket needs to be big enough for the
\ entire array, otherwise we'd need extra passes to figure out how big each one
\ needs to be and there'd be more code and we have tons of RAM.
\ since this is meant to be used for the stage, a reasonable maximum limit is
\ 8192 items which works out to 1MB.

\ $0fff f000 <--- significant bits.

[undefined] src [if]
    0 value src
    0 value dest
    : src!  to src ;
    : dest!  to dest ;
[then]

define rsorting
  decimal

  $0000f000 constant nyb0
  nyb0 value radix
  12 constant pass1shift
  pass1shift value radixShift

  15 constant bucketShift
  8192 constant #max  \ actual max is #MAX - 1, one cell is reserved for bucket count

  defer @key  ( item -- key )

  create table0  #max cells 16 * allot
  create table1  #max cells 16 * allot
  table0 value table

  : other  table table0 = if  table1  else  table0  then  to table ;
  : radix++  radix 4 << to radix  4 +to radixShift ;
  : bucket  ( bucket# -- bucket )  bucketShift <<  table + ;
  : !bucket  ( n bucket# -- )  bucket 1 over +! dup @ cells + ! ;
  : /buckets  ( -- )  16 0 do  0 i bucket !  loop ;

  : irpass  ( first-item count -- )
    cells bounds ?do  i @ dup @key  radix and  radixShift >>  !bucket  cell +loop ;

  : tablepass  ( -- )
    other /buckets  16 0 do  other i bucket @+ other irpass  loop  radix++ ;

  : irinit  ( xt -- )
    is @key
    pass1shift to radixShift  nyb0 to radix
    table0 to table  /buckets  other  /buckets  other ;

  : !result  ( -- )
    16 0 do  i bucket @+ cells dup >r  dest swap move  r> +to dest  loop ;

only forth definitions also rsorting
fixed
: rsort  ( addr cells xt -- )  \ destructive, XT is @KEY  ( addr -- key )
    swap 1i swap
    over 0= if 2drop drop exit then
    irinit  over src!  irpass  radix++
    tablepass tablepass tablepass
    src dest!  !result
; 

\ test
fixed
marker dispose
create sortable  4123 , 9 , 5 , 1 , 401 , 234 , 100 , 5 , 99 , 4123 , 23 , 3 , 400 , 50 ,
: test  <> abort" radix sort test failed!" ;
\ hex sortable 14 cells idump fix
sortable 14 ' noop rsort
\ hex sortable 14 cells idump fix
sortable
@+ 1 test
@+ 3 test
@+ 5 test
@+ 5 test
@+ 9 test
@+ 23 test
@+ 50 test
@+ 99 test
@+ 100 test
@+ 234 test
@+ 400 test
@+ 401 test
@+ 4123 test
@+ 4123 test
drop
cr .( == RSORT tests passed. == )
dispose

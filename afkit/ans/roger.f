: zcount ( zaddr - addr n )   dup dup if  65535 0 scan drop over - then ;
: zlength ( zaddr - n )   zcount nip ;
: zplace ( from n to - )   tuck over + >r  cmove  0 r> c! ;
: zappend ( from n to - )   zcount + zplace ;
[undefined] third [if] : third  >r over r> swap ; [then]
[undefined] @+ [if] : @+  dup @ swap cell+ swap ; [then]
: u+  rot + swap ;  \ "under plus"
: ?lit  state @ if postpone literal then ; 
: do postpone ?do ; immediate
: for  s" 0 do" evaluate ; immediate
: /allot  here over allot swap erase ;
: allotment  here swap /allot ;
: move,   here over allot swap move ;
: h?  @ h. ;
: reclaim  h ! ;
: ]#  ] postpone literal ;
: <<  s" lshift" evaluate ; immediate
: >>  s" rshift" evaluate ; immediate
: bit  dup constant  1 lshift ;
: clamp  ( n low high - n ) -rot max min ;
: and!  dup >r @ and r> ! ;
: or!   dup >r @ or r> ! ;
: xor!   dup >r @ xor r> ! ;
: not!   >r invert r> and! ;
: @!  dup @ >r ! r> ;
: bounds  over + swap ;
: lastbody  last @ name> >body ;
: ccount  dup c@ 1 u+ ;
: .name  dup if body> >name ccount type space else . then ;
: $=  compare 0= ;

: count  dup @ cell u+ ;
: string,  dup , move, ;
: place  2dup ! cell+ swap move ;
: append  2dup 2>r count + swap move 2r> +! ;
: count!  ! ;
: count+!  +! ;
: ,"  [char] " parse string, ;
: included  2dup cr ." [Include] " type included ;

\ WITHIN? - lo and hi are inclusive
: within? ( n lo hi - flag )  over - >r - r> #1 + u< ;

: ifill  ( addr count val - )  -rot  0 do  over !+  loop  2drop ;
: ierase   0 ifill ;
: imove  ( from to count - )  cells move ;
: time?  ( xt - ) ucounter 2>r  execute  ucounter 2r> d-  d>s  . ;

: kbytes  #1024 * ;
: megs    #1048576 * ;
: udup  over swap ;
: 2,  swap , , ;
: 3,  rot , swap , , ;
: 4,  2swap swap , , swap , , ;
: :make  :noname  postpone [  [compile] is  ] ;
: reverse   ( ... count - ... ) 1 + 1 ?do i 1 - roll loop ;
: ;then  s" exit then" evaluate ; immediate
: free  dup 0= if ;then free ;

\ Random numbers
0 VALUE seed
: /rnd  ucounter drop to seed ;  /rnd
: random ( - u ) seed $107465 * $234567 + DUP TO seed ;
: rnd ( n - 0..n-1 ) random um* nip ;

\ readability helper: slang words.  callable once then they self-destruct.  
: ?compile  state @ if compile, else execute then ;
: does-slang  does> dup @ ?compile  0 swap body> >name c! ;
: :slang  ( - <name> <code> ; )   create immediate here 0 , does-slang  :noname swap ! ;

\ vocabulary helpers
: define
    >in @
    exists if >in ! also ' execute definitions exit then  \ already defined
    dup >in !  vocabulary
    >in !  also ' execute definitions ;
: using  only forth definitions also ;
vocabulary internal

\ on-stack vector stuff (roger)
: 2!  swap over cell+ ! ! ;
: 2@  dup @ swap cell+ @ ;
: 2+!  swap over cell+ +! +! ;
: 3@  dup @ swap cell+ dup @ swap cell+ @ ;
: 4@  dup @ swap cell+ dup @ swap cell+ dup @ swap cell+ @ ;
: 3!  dup >r  2 cells + !  r> 2! ;
: 4!  dup >r  2 cells + 2! r> 2! ;
: 2min  rot min >r min r> ;
: 2max  rot max >r max r> ;
: 2+  rot + >r + r> ;
: 2-  rot swap - >r - r> ;
: 2negate  negate swap negate swap ;
: 2clamp  ( x y lowx lowy highx highy - x y ) 2>r 2max 2r> 2min ;

\ Word tools
: defined ( - c-addr 0 | xt -1 | - xt 1 )  bl word find ;
: exists ( - flag )   defined 0 <> nip ;

\ compile and exec
: :now  :noname  [char] ; parse evaluate  postpone ;  execute ;

include afkit/ans/depend.f

defer alert  ( a c - )
:make alert  type true abort ;

\ TODO
\ [ ] overflow checking

: cellstack  here  swap  0 , cells /allot ;
: cellstack:  ( max-size -- <name> )  create cellstack drop ;
: #pushed  @ ;
: truncate  ( cs newsize -- )  swap ! ;
: pop  ( cs -- val )  >r  r@ @ 0= abort" ERROR: Stack object underflow." r@ dup @ cells + @  -1 r> +! ;
: push  ( val cs -- )  >r  1 r@ +!   r> dup @ cells + !  ;
: pushes  ( ... cs n -- ) swap locals| s |  0 ?do  s push  loop ;
: pops    ( cs n -- ... ) swap locals| s |  0 ?do  s pop  loop ;
: scount  ( cs -- addr count ) @+  ;
: sbounds  ( cs -- end start ) scount cells over + swap ;
: []  ( cs n -- addr )  1 + cells + ;
: nth  swap [] ;
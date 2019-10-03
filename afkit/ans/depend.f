[undefined] depend [if] 

: defined ( - <word> c-addr 0 | xt -1 | - xt 1 )  bl word find ;
: exists ( - <word> flag )   defined 0 <> nip ;

\ : (create)
\     get-order get-current
\     only forth definitions create
\     set-current set-order
\ ;

: include  ( - <path> )
    >in @ >r  create   r> >in !  bl parse included ;

: depend  ( - <path> )
    >in @  exists if drop exit then  >in !
    include ;

[then]
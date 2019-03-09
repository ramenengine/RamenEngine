[undefined] depend [if] 

: defined ( - <word> c-addr 0 | xt -1 | - xt 1 )  bl word find ;
: exists ( - <word> flag )   defined 0 <> nip ;

\ Conditional INCLUDE
: include  ( - <path> )
    >in @ >r  bl parse included  r> >in !  create ;
: depend  ( - <path> )
    >in @  exists if drop exit then  >in !
    include ;

[then]
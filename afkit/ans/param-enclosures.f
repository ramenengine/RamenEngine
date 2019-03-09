\ Parameter enclosures
\ a simple runtime relative stack depth checking mechanism.

\ example:
\   1( 123 )      \ stack ok, nothing happens
\   1( 123 321 )  \ throws an error
\   1( )          \ throws an error

0 value (depth)
: 1(  ( - )  state @ if  s" depth >r" evaluate  else  depth to (depth)  then ; immediate
: (stackerr)  - #1 <> abort" stack check error" ;
: )   ( ... - ... )
    state @ if  s" depth r> (stackerr) " evaluate
            else  depth (depth) (stackerr) then ; immediate


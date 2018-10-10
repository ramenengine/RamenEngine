
\ cell array iterating tools
: batch  ( ... addr n xt -- ... )  ( ... addr -- ... )
    >code -rot  cells bounds do
        i swap dup >r call  r>  cell +loop
    drop ;

: batch>  ( addr n -- <code> )  ( addr -- )
    r> code> batch ;

: ?batch  ( ... addr xt -- ... )  ( ... addr -- ... )  \ -1 is terminator
    >code begin  over @ 0 >=  while
        2dup 2>r  call  r> r> cell+ swap
    repeat  2drop ;

: ?batch>  ( addr -- <code> )  ( addr -- )
    r> code> ?batch ;
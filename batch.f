
\ cell array iterating tools
: batch  ( ... addr n xt -- ... )  ( ... addr -- ... )
    >code -rot  cells bounds do
        i swap dup >r call  r>  cell +loop
    drop ;

\ addr should be a list of cells terminated with -1
: ?batch  ( ... addr xt -- ... )  ( ... addr -- ... )  
    >code begin  over @ 0 >=  while
        2dup 2>r  call  r> r> cell+ swap
    repeat  2drop ;

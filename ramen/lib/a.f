0 value a@
: @+  a@ @  cell +to a@ ;
: !+  a@ !  cell +to a@ ;
: a!  to a@ ;
: a!>  r> a@ >r swap a! call r> a! ;
: +a  cells +to a@ ;
: c+a  +to a@ ;
: c!+  a@ c! #1 +to a@ ;
: c@+  a@ c@ #1 +to a@ ;
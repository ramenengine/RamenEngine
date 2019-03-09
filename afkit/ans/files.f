decimal

: file!  ( addr count filename c - )  \ file store
  w/o create-file throw >r
  r@ write-file throw
  r> close-file throw ;

: @file  ( filename c dest maxsize - )  \ fetch file into a mem range
  locals| maxsize dest c filename |
  filename c r/o open-file throw >r
  dest r@ file-size throw drop maxsize min  r@ read-file throw drop
  r> close-file throw ;


\ system heap version

: file@ ( filename c - mem size )
  r/o open-file throw >r
  r@ file-size throw d>s dup dup allocate throw dup rot
  r@ read-file throw drop
  r> close-file throw
  swap ;

\ dictionary version

: file  ( filename c - addr size )
  file@  2dup here dup >r  swap  dup /allot  move  swap free throw  r> swap ;

: file,  ( filename c - )  \ file comma
  file 2drop ;

: ending ( addr len char - addr len )
   >r begin  2dup r@ scan
      ?dup while  2swap 2drop  #1 /string
   repeat  r> 2drop ;

: -EXT ( a n - a n )   2DUP  [CHAR] . ENDING  NIP -  1-  0 MAX ;

[defined] linux [if]
: slashes  2dup  over + swap do  i c@ [char] \ = if  [char] / i c!  then  #1 +loop ;
: -filename ( a n - a n )  slashes  2dup  [char] / ending  nip - ;
: -PATH ( a n - a n )   slashes  [CHAR] / ENDING  0 MAX ;
[else]
: slashes  2dup  over + swap do  i c@ [char] / = if  [char] \ i c!  then  #1 +loop ;
: -filename ( a n - a n )  slashes 2dup  [char] \ ending  nip - ;
: -PATH ( a n - a n )   slashes  [CHAR] \ ENDING  0 MAX ;
[then]

: 0file  ( adr c len - )
  locals| len c adr |
    here len erase  here len adr c file! ;

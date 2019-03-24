: zcount ( zaddr - addr n )   dup dup if  65535 0 scan drop over - then ;
: zlength ( zaddr - n )   zcount nip ;
: zplace ( from n to - )   tuck over + >r  cmove  0 r> c! ;
: zappend ( from n to - )   zcount + zplace ;
create $buffers  16384 allot  \ string concatenation buffer stack (circular)
variable >s                   \ pointer into $buffers
: s[  ( adr c - )  >s @ 256 + 16383 and >s !  >s @ $buffers + place ;
: +s  ( adr c - )  >s @ $buffers + append ;
: +c  ( c - )     >s @ $buffers + count + c!  1 >s @ $buffers + +! ;
create $outbufs  16384 allot \ output buffers; circular stack of buffers
variable >out
: ]s  ( - adr c )  \ fetch finished string
  >s @ $buffers + count >out @ $outbufs + place
  >out @ $outbufs + count
  >out @ 256 + 16383 and >out !
  >s @ 256 - 16383 and >s ! ;
create zbuf 65537 allot
: zstring  ( addr c - zaddr )   zbuf zplace  zbuf ;
: addchar  ( c adr - )   dup >r  count + c!  1 r> c+! ;
: uncount  ( adr c - adr-1 )   drop 1 - ;
: strjoin  ( first c second c - first+second c )   2swap s[ +s ]s ;
\ : input  ( adr c - )   over 1 +  swap accept  swap  c! ;
: <filespec>  ( - <rol> addr c )  0 parse -trailing bl skip ;       \ rol=remainder of line

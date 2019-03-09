cd afkit/dep/zlib
[defined] linux [if]
    library libz.so
[else]
    library libzlib
[then]
cd ../../..

function: compress ( dest-adr &destlen src-adr srclen -- result )
function: uncompress ( dest-adr &destlen src-adr srclen -- result )

variable destlen
: decompress  ( src #len dest #len - #outputlen )
    destlen !
    destlen 2swap uncompress dup if  h.  -1 abort" Zlib error"  else drop then
    destlen @ ;


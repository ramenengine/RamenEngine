\ Basic Fixed-point ops (assuming no fixed-point literal support)
\ the following words will be redefined
\   * / /mod
\   loop
\ the following words will remain untouched
\   + - mod */
\ the following words will use prefixes to avoid collision with float words
\   pfloor pceil
\ additional words for conversion to and from other formats
\   1p 2p 3p 4p  --- int to fixed
\   1i 2i 3i 4i  --- fixed to int
\   1f 2f 3f 4f  --- fixed to float

\ words should take fixed unless otherwise noted:
\   ( n -- )  <-- fixed
\   ( n# -- )  < -- integer  ( #n ) means # of n's, in fixed point.  ( #n# -- ) means # of n's, in integer.

12 constant /FRAC
$FFFFF000 constant INT_MASK
$00000FFF constant FRAC_MASK
: FPGRAN  s" 4096e" evaluate ; immediate
4096  constant PGRAN
$1000 constant 1.0

: i*  * ;
: i/  / ;
: iloop  postpone loop ; immediate

[in-platform] sf [if]
    \ SwiftForth/X86 only - arithmetic shift
    ICODE ARSHIFT ( x1 n -- x2 )
       EBX ECX MOV                      \ shift count in ecx
       POP(EBX)                         \ get new tos
       EBX CL SAR                       \ and shift bits right
       RET   END-CODE
    ICODE ALSHIFT ( x1 n -- x2 )
       EBX ECX MOV                      \ shift count in ecx
       POP(EBX)                         \ get new tos
       EBX CL SHL                       \ and shift bits right
       RET   END-CODE
[else]
    cr .( Fatal error: Fixops.f doesn't support this platform: )  platform type
    quit
[then]

\ NTS: keep these as one-liners, I might make them macros...
: 1p  s" /FRAC alshift" evaluate ; immediate
: 2p  1p swap 1p swap ;
: 3p  1p rot 1p rot 1p rot ;
: 4p  2p 2swap 2p 2swap ;
: 1i  s" /frac arshift" evaluate ; immediate
: 2i  swap 1i swap 1i ;
: 3i  rot 1i rot 1i rot 1i ;
: 4i  2i 2swap 2i 2swap ;
: 1f  s>f FPGRAN f/ ;
: 2f  swap 1f 1f ;
: 3f  rot 1f 2f ;
: 4f  2swap 2f 2f ;
: pfloor  INT_MASK and ;
: pceil   pfloor 1.0 + ;
: 2pfloor  pfloor swap pfloor swap ;
: 2pceil   pceil swap pceil swap ;
: f>p  FPGRAN f* f>s ;

wordlist constant fixpointing
: fixed    fixpointing +order decimal ;  \ assumes no support for fixed point literals
: decimal  fixpointing -order decimal ;

\ NTS: keep these as one-liners, I might make them macros...
fixed definitions
    : *  ( n n -- n )  1f s>f f* f>s ;
    : /  ( n n -- n )  swap s>f 1f f/ f>s ;
    : /mod  ( n n -- r q ) 2dup mod -rot / ;
    : loop  s" 1.0 +loop" evaluate ; immediate
previous definitions

\ Literal helpers
: .0    1p ;
: .125  1p $200 or ;
: .25   1p $400 or ;
: .375  1p $600 or ;
: .5    1p $800 or ;
: .625  1p $a00 or ;
: .75   1p $c00 or ;
: .875  1p $e00 or ;

\ External library helpers
: 1af  1f 1sf ;                                     \ covert a fixed point value to allegro on-stack float
: 2af  1f 1f 1sf 1sf ;
: 3af  1f 1f 1f 1sf 1sf 1sf ;
: 4af  1f 1f 1f 1f 1sf 1sf 1sf 1sf ;

\ advanced fixed point math
: cos  ( deg -- n )   1f cos f>p ;
: sin  ( deg -- n )   1f sin f>p ;
: asin  ( n -- deg )  1f fasin r>d f>p ;
: acos  ( n -- deg )  1f facos r>d f>p ;
: lerp  ( src dest factor -- )  >r over - r> * + ;
: anglerp  ( src dest factor -- )
  >r  over -  360 mod  540 +  360 mod  180 -  r> * + ;
: sqrt  ( n -- n )  1f fsqrt f>p ;
: atan  ( n -- n )  1f fatan f>p ;
: atan2 ( n n -- n )  2f fatan2 f>p ;
: log2  ( n -- n )  1e 1f y*log2(x) f>p ;  \ binary logarithm (for fixed-point)
: rescale  ( n min1 max1 min2 max2 -- n )  \ transform a number from one range to another.
  locals| max2 min2 max1 min1 n |
  n min1 -  max1 min1 -  /  max2 min2 -  *  min2 + ;
: >rad  1f  d>r  f>p ;

\ Color stuff
: c>p  ( c - n )  \ convert from 0...255 (byte) to 0...1.0 (fixed)
  4 <<  1 $ff0 */ ;
: byt  dup $ff and c>p swap 8 >> ;
: 4reverse   swap 2swap swap ;
: 3reverse   swap rot ;
: >rgba  ( val -- r g b a ) byt byt byt byt drop >r 3reverse r> ;
: >rgb   ( val -- r g b )  byt byt byt drop 3reverse ;

\ on-stack vector stuff (fixed point specific)
: 2*  rot * >r * r> ;
: 2/  rot swap / >r / r> ;
: 2mod  rot swap mod >r mod r> ;

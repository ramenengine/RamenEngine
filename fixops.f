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
\   1pf 2pf 3pf 4pf  --- fixed to float

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

: 1p  state @ if /frac postpone literal postpone lshift else /frac lshift then ; immediate


[in-platform] sf [if]
    icode arshift ( x1 n -- x2 ) 
       ebx ecx mov                      \ shift count in ecx 
       pop(ebx)                         \ get new tos 
       ebx cl sar                       \ and shift bits right 
       ret   end-code
    package OPTIMIZING-COMPILER
        optimize (literal) arshift with lit-shift assemble sar
    end-package
    : 1i  state @ if /frac postpone literal postpone arshift  else  /frac arshift then ; immediate
[else]
    : 1i  state @ if 1.0 postpone literal postpone / else 1.0 / then ; immediate
[then]

: 2p  1p swap 1p swap ;
: 3p  1p rot 1p rot 1p rot ;
: 4p  2p 2swap 2p 2swap ;
: 2i  swap 1i swap 1i ;
: 3i  >r 1i swap 1i swap r> 1i ;
: 4i  swap 1i swap 1i  2>r  swap 1i swap 1i  2r> ;
: 1pf  s>f FPGRAN f/ ;
: 2pf  swap 1pf 1pf ;
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
    : *  ( n n -- n )  1pf s>f f* f>s ;
    : /  ( n n -- n )  swap s>f 1pf f/ f>s ;
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
: 1af  1pf 1sf ;                                     \ covert a fixed point value to allegro on-stack float
: 2af  1pf 1pf 1sf 1sf ;
: 3af  1pf 1pf 1pf 1sf 1sf 1sf ;
: 4af  1pf 1pf 1pf 1pf 1sf 1sf 1sf 1sf ;

\ advanced fixed point math
: cos  ( deg -- n )   1pf cos f>p ;
: sin  ( deg -- n )   1pf sin f>p ;
: asin  ( n -- deg )  1pf fasin r>d f>p ;
: acos  ( n -- deg )  1pf facos r>d f>p ;
: lerp  ( src dest factor -- )  >r over - r> * + ;
: anglerp  ( src dest factor -- )
  >r  over -  360 mod  540 +  360 mod  180 -  r> * + ;
: sqrt  ( n -- n )  1pf fsqrt f>p ;
: atan  ( n -- n )  1pf fatan f>p ;
: atan2 ( n n -- n )  2pf fatan2 f>p ;
: log2  ( n -- n )  1e 1pf y*log2(x) f>p ;  \ binary logarithm (for fixed-point)
: rescale  ( n min1 max1 min2 max2 -- n )  \ transform a number from one range to another.
  locals| max2 min2 max1 min1 n |
  n min1 -  max1 min1 -  /  max2 min2 -  *  min2 + ;
: >rad  1pf  d>r  f>p ;

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

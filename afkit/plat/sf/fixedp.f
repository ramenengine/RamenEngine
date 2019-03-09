\ this module simplifies game dev by making fixed point numbers THE DEFAULT.
\ the new format will be 20:12.
\   (that provides a range of roughly -0.5m~0.5m with a granularity of 1/4096)
\ NOTE TO SELF: this number system isn't meant to replace floats.  floats should
\   continue to be used where precision or wide range is needed.
\ the following bits of the Forth system will be modified:
\   literals will by default be interpreted as fixed point.  regardless of
\     if there is a decimal point.
\   to specify integer literals, suffix with #.
\   a new "base" for display will be added ( FIXED ) which
\     will affect .s . ? and friends
\ the following words will be redefined or otherwise altered
\   * / /mod .s . ?
\   ++ --
\   loop
\ the following words will remain untouched
\   + - mod
\   "compiler oriented words": cells allot /allot erase move fill
\ the following words will use prefixes to avoid collision with float words
\   pfloor pceil
\ additional words for conversion to other formats
\   1i 2i 3i 4i
\   1pf 2pf
\ stack diagrams
\   n = fixed-point
\   i = integer

[in-platform] sf [if]
    requires fpmath
[then]

only forth definitions

[undefined] s[ [if]
    create $buffers  16384 allot  \ string concatenation buffer stack (circular)
    variable >s                   \ pointer into $buffers
    : s[  ( adr c - )  >s @ 256 + 16383 and >s !  >s @ $buffers + place ;
    : +s  ( adr c - )  >s @ $buffers + append ;
    : c+s  ( c - )     >s @ $buffers + count + c!  1 >s @ $buffers + c+! ;
    create $outbufs  16384 allot \ output buffers; circular stack of buffers
    variable >out
    : ]s  ( - adr c )  \ fetch finished string
      >s @ $buffers + count >out @ $outbufs + place
      >out @ $outbufs + count
      >out @ 256 + 16383 and >out !
      >s @ 256 - 16383 and >s ! ;
[then]

only forth definitions
12 constant /FRAC
$FFFFF000 constant INT_MASK
$00000FFF constant FRAC_MASK
\ 4096e fconstant FPGRAN
\ #define FPGRAN 4096e
: FPGRAN  s" 4096e" evaluate ; immediate
4096  constant PGRAN
$1000 constant 1.0
1.0 negate constant -1.0
variable ints  ints on  \ set/disable integer mode on both display and interpretation

wordlist constant fixpointing

\ private

: ?:  >in @  exists if  0 parse 2drop  drop exit  else  >in !  :  then ;

?: 1p  state @ if /frac postpone literal postpone lshift else /frac lshift then ; immediate
?: 1i  state @ if 1.0 postpone literal postpone / else 1.0 / then ; immediate

?: 2p  1p swap 1p swap ;
?: 2i  swap 1i swap 1i ;
?: 3i  rot 1i rot 1i rot 1i ;
?: 4i  2i 2swap 2i 2swap ;
?: 1pf  s>f FPGRAN f/ ;
?: 2pf  swap 1pf 1pf ;
?: pfloor  INT_MASK and ;
?: pceil   pfloor 1.0 + ;
?: 2pfloor  pfloor swap pfloor swap ;
?: 2pceil   pceil swap pceil swap ;
?: f>p  FPGRAN f* f>s ;
?: p*  1pf s>f f* f>s ;
?: p/  swap s>f 1pf f/ f>s ;
?: i.  base @ >r decimal . r> base ! ;
?: i?  @ i. ;
?: p.  1pf f. ;

fixpointing +order definitions
    : *  ( n n - n )  p* ;
    : /  ( n n - n )  p/ ;
    : /mod  ( n n - r q ) 2dup mod -rot p/ pfloor ;
    : 2*  rot p* >r p* r> ;
    : 2/  rot swap p/ >r p/ r> ;
    : .   ints @ if  i.  else  p.  then ;
    : ?   @ . ;
    : 2.  swap . . ;
    : 3.  rot . 2. ;
    : 2?  dup ? cell+ ? ;
    : 3?  dup ? cell+ dup ? cell+ ? ;

\ --------------------------- swiftforth-specific -----------------------------
only forth definitions
\ extend literals to support fixed-point
variable sign
: pconvert ( a - 0 | a -1 ) ( - | r )
   <sign>    ( a c f)  drop [char] - = sign !
   <digits>  ( a d n)  0= if 2drop drop 0 exit then d>f
   <dot>     ( a c f)  0= if fdrop 2drop 0 exit then drop
   <digits>  ( a d n)  -rot d>f t10** f/ f+
                       sign @ if fnegate then
\   <e>       ( a c f)  if fdrop 2drop 0 exit then drop
   -1 ;

: >pfloat ( caddr n - true | false ) ( - r )
   r-buf  r@ zplace
   r@ pconvert ( 0 | a\f ) if
      r> zcount + = dup ?exit fdrop exit
   then r> drop 0 ;

: pnumber? ( addr len 0 | p.. xt - addr len 0 | p.. xt )
  dup ?exit drop
  2dup >pfloat if
    2drop
    FPGRAN f* (f>s) ['] literal
    exit
  then
  0 ;

\ decimal-point-less conversion
: pnumber2? (  addr len 0  |  ... xt  -  addr len 0  |  ... xt  )
  dup ?exit drop
  base @ 10 =  ints @ 0 = and  if
    2dup
      number? 1 = if
        nip nip  /FRAC lshift  ['] literal
        exit
      then
  then  0  ;

fixpointing +order definitions
\    : .S ( ? - ? )
\      CR DEPTH 0> IF DEPTH 0 ?DO S0 @ I 1+ CELLS - @ . LOOP THEN
\      DEPTH 0< ABORT" Underflow"
\      FDEPTH ?DUP IF
\        ."  FSTACK: "
\        0  DO  I' I - 1- FPICK N.  LOOP
\      THEN ;

\ -------- Add fixed-point interpreter to SwiftForth -------
only forth definitions fixpointing +order

PACKAGE STATUS-TOOLS
    public
    [undefined] linux [if]
        : SB.BASE2  ( - )
          ints @ 0 = if
            s" FIX"
          else
            BASE @ PSTK (.BASE)
          then
          1 SF-STATUS PANE-TYPE ;
        : SB.STACK2 ( - )
          ints @ if
            PSTK Z(.S) ZCOUNT s[
          else
            s" " s[
            DEPTH 0 >= IF
              DEPTH 0 ?DO
                S0 @ I 1 + CELLS - @
                dup 0 < if s"  " +s then
                1pf 3 (f.) +s
              LOOP
            ELSE
              s" Underflow" +s
            THEN
          then
          FDEPTH ?DUP IF
            s"  FSTACK:" +s
            0 DO  I' I - 1 - FPICK 3 (f.) +s  LOOP
          THEN
          ]s 0 SF-STATUS PANE-RIGHT ;

        : STATUS.STACK2 ( - )    SB.BASE2  SB.STACK2 ;

        ' status.stack2 is .stack
    [then] \ not linux

    ' pnumber2? number-conversion >chain
    ' pnumber? number-conversion >chain

END-PACKAGE

\ ------------------------------------------------------------
only forth fixpointing +order definitions
    : cells  1i #2 lshift ;
    : cell/  #2 rshift 1p ;
    : bytes  1i ;
    : loop  s" 1.0 +loop" evaluate ; immediate
    : <<      1i lshift ;
    : >>      1i rshift ;
    : .0 ; immediate
    : ifill  swap 1i swap ifill ;
    : ierase  0 ifill ;
    : imove  1i imove ;
    : kbytes  1i #1024 i* ;
    : megs    1i #1048576 i* ;
    : ++  1.0 swap +! ;
    : --  -1.0 swap +! ;
    : reverse  ( ... count - ... ) 1 + 1 ?do i 1 - 1i roll loop ;

only forth definitions fixpointing +order
: fixed   fixpointing +order  ints off #10 base ! ;
: decimal fixpointing -order  ints on  #10 base ! ;
: hex     fixpointing -order  ints on  hex ;
: include   ints @ >r  fixed include  r> ?exit fixed  ;
: included  ints @ >r  fixed included  r> ?exit fixed  ;
: (only)  only  execute   ints @ ?exit  fixpointing +order ;
: only
    state @ if  postpone [']  postpone (only)
            else  '  (only)  then  ; immediate


: definitions
    get-order over fixpointing = if  fixpointing -order  definitions  fixpointing +order
    else  definitions  then  set-order ;

: using  only forth definitions also ;


fixed

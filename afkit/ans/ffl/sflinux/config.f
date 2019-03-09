\ ==============================================================================
\
\                  config - the config in the ffl
\
\             Copyright (C) 2005-2007  Dick van Oudheusden
\
\ This library is free software; you can redistribute it and/or
\ modify it under the terms of the GNU General Public
\ License as published by the Free Software Foundation; either
\ version 2 of the License, or (at your option) any later version.
\
\ This library is distributed in the hope that it will be useful,
\ but WITHOUT ANY WARRANTY; without even the implied warranty of
\ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
\ General Public License for more details.
\
\ You should have received a copy of the GNU General Public
\ License along with this library; if not, write to the Free
\ Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
\
\ ==============================================================================
\
\  ...
\
\ ==============================================================================
\
\ This file is for SwiftForth.
\
\ ==============================================================================

[undefined] f@ [if]
  get-order get-current only forth definitions
  requires fpmath
  set-current set-order
[then]

[UNDEFINED] ffl.version [IF]

aka counter ms@

( config = Forth system specific words )
( The config module contains the extension and missing words for a forth system.)

000700 constant ffl.version

( Private words )

variable ffl.endian   1 ffl.endian !


( System Settings )

create end-of-line
  1 c,  $0a c,

s" ADDRESS-UNIT-BITS" environment? 0= [IF] 8 [THEN]
  constant #bits/byte   ( -- +n = Number of bits in a byte )

#bits/byte 1 chars *
  constant #bits/char   ( -- +n = Number of bits in a char )

#bits/byte cell *
  constant #bits/cell   ( -- +n = Number of bits in a cell )

ffl.endian c@ 0=
  constant bigendian?   ( -- flag = Check for bigendian hardware )

create overrule:parse\" ( -- = VFX Forth ships with an incompatible parse\" )


( Extension words )

1 chars 1 = [IF]
  : char/		\ n1 -- n2 = Convert address units to chars
  ; immediate
[ELSE]
  : char/
    1 chars /
  ;
[THEN]

\ \ u1 u2 -- u3 = Rotate u1 u2 bits to the left
\ icode lroll
\   0 [EBP] ECX MOV
\   4 # EBP ADD
\   ecx ebx rol
\ ret end-code
\
\ \ u1 u2 -- u3 = Rotate u1 u2 bits to the right
\ icode rroll
\   0 [EBP] ECX MOV
\   4 # EBP ADD
\   ecx ebx ror
\ ret end-code

s" MAX-U" environment? drop constant max-ms@	\ -- u
\ Maximum value of the milliseconds timer

: 0!		\ a-addr -- = Set zero in address
  0 swap !  ;

0 constant nil	\ -- nil ; Nil constant

: nil!		\ a-addr -- ; Set nil in address )
  nil swap !  ;

: nil=		\ addr -- flag ; Check for nil
  nil =  ;

: nil<>		\ addr -- flag = Check for unequal to nil
  nil <>  ;

: nil<>?	\ addr -- false | addr true
\ If addr is nil, then return false, else return address with true
  ?dup  ;

: ?free		\ addr -- wior ; Free the address if not nil
  dup nil<> IF
    free
  ELSE
    drop 0
  THEN
;

: 1+!		\ a-addr -- = Increase contents of address by 1
  1 swap +! ;

: 1-!		\ a-addr -- = Decrease contents of address by 1
  -1 swap +! ;

: @!		\ x1 a-addr -- x2 = First fetch the contents x2 and then store the new value x1 )
  dup @ -rot !  ;

[undefined] u<= [if]
: u<=
  u> 0=  ;
[then]

: 0>=
  0< 0=  ;

: 0<=
  0> 0=  ;

: ?comp  state @ 0= abort" Word can only be used while compiling!" ;

[UNDEFINED] rdrop [IF]
: rdrop		\ -- ; R: x -- ; same as R> DROP
  ?comp  postpone r>  postpone drop  ;  immediate
[THEN]

: r'@              ( R: x1 x2 -- x1 x2; -- x1 = Fetch the second cell on the return stack )
  ?comp postpone 2r@ postpone drop  ; immediate

\ : d<>		\ d1 d2 -- flag
\   d- or 0<>  ;
\   0 ud.r space  ;

: sgn		\ n1 -- n2
\ Determine the sign of the number, return [-1,0,1] )
  -1 max 1 min  ;

aka upper upc

\ : icompare         ( c-addr1 u1 c-addr2 u2 -- n = Compare case-insensitive two strings, return [-1,0,1] )
\   rot swap 2swap 2over
\   min 0 ?DO
\     over c@ upc over c@ upc - sgn ?dup IF
\       >r 2drop 2drop r>
\       unloop
\       exit
\     THEN
\     1 chars + swap 1 chars + swap
\   LOOP
\   2drop
\   - sgn
\ ;
aka compare icompare


: <=>		\ n1 n2 -- n
\ Compare two numbers and return the compare result [-1,0,1] )
  2dup = if
    2drop 0
  else
    < 1 lshift 1 or
  then
;

: index2offset	\ n1 n2 -- n3
\ Convert the index n1 [-length..length] with length n2 into the
\ offset n3 [0..length].
  over 0< IF
    +
  ELSE
    drop
  THEN
;


( Float extension words )

1 floats constant float  ( -- n = The size of one float )

0E+0 fconstant 0e+0  ( F: -- r = Float constant 0.0 )
1E+0 fconstant 1e+0  ( F: -- r = Float constant 1.0 )
2E+0 fconstant 2e+0  ( F: -- r = Float constant 2.0 )

: f-rot            ( F: r1 r2 r3 -- r3 r1 r2 = Rotate counter clockwise three floats )
  frot frot
;


: f>r  s" f> >r" evaluate ; immediate
: fr>  s" r> >f" evaluate ; immediate
: fr@  s" r@ >f" evaluate ; immediate

: ftuck		\ F: r1 r2 -- r2 r1 r2
  fswap fover
;

: f2dup		\ F: f1 f2 -- f1 f2 f1 f2
  fover fover  ;

( Exceptions )

THROW#

s" Index out of range" >throw ENUM exp-index-out-of-range
s" Invalid state" >throw ENUM exp-invalid-state
s" No data available" >throw ENUM exp-no-data
s" Invalid parameters" >throw ENUM exp-invalid-parameters
s" Wrong file type" >throw ENUM exp-wrong-file-type
s" Wrong file version" >throw ENUM exp-wrong-file-version
s" Wrong file data" >throw ENUM exp-wrong-file-data
s" Wrong checksum" >throw ENUM exp-wrong-checksum
s" Wrong length" >throw ENUM exp-wrong-length
s" Invalid data" >throw ENUM exp-invalid-data

to THROW#

\ ==============================================================================

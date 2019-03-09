\ Words for passing floats and doubles to DLL's

\ iCODE 4sf  ( f: x y z t - ) ( s: - x y z t )
\   4 >fs \ make sure data on hardware stack
\   16 # EBP SUB \ room for 4 integers and tos
\   12 [EBP] DWORD FSTP             \ convert t
\    0 [EBP] DWORD FSTP             \ convert z
\    4 [EBP] DWORD FSTP             \ convert y
\    8 [EBP] DWORD FSTP             \ convert x
\   12 [EBP] EBX XCHG               \ swap t and old tos
\   RET END-CODE
\ 
\ iCODE 1df  ( f: x - ) ( s: - xl xh )
\   >f                      \ make sure data on hardware stack
\   8 # EBP SUB \ make room for double
\   0 [EBP] QWORD FSTP \ convert
\   4 [EBP] EBX XCHG \ swap xh and old tos
\   RET END-CODE
\ 
\ iCODE 3sf  ( f: x y z - ) ( s: - x y z )
\   3 >fs                     \ make sure data on hardware stack
\   12 # EBP SUB                \ room for 3 integers and tos
\    8 [EBP] DWORD FSTP             \ convert z
\    0 [EBP] DWORD FSTP             \ convert y
\    4 [EBP] DWORD FSTP             \ convert x
\    8 [EBP] EBX XCHG               \ swap z and old tos
\   RET END-CODE
\ 
\ iCODE 2sf  ( f: x y z - ) ( s: - x y z )
\   2 >fs                     \ make sure data on hardware stack
\   8 # EBP SUB                \ room for 2 integers and tos
\    4 [EBP] DWORD FSTP             \ convert y
\    0 [EBP] DWORD FSTP             \ convert x
\    4 [EBP] EBX XCHG               \ swap z and old tos
\   RET END-CODE
\ 
\ iCODE 1sf  ( f: x - ) ( s: - x )
\   1 >fs                     \ make sure data on hardware stack
\    4 # EBP SUB                \ room for 1 integers and tos
\    0 [EBP] DWORD FSTP             \ convert x
\    0 [EBP] EBX XCHG               \ swap x and old tos
\   RET END-CODE


variable sf
: 1sf  sf sf! sf @ ;
: 2sf  1sf 1sf swap ;
: 3sf  1sf 2sf rot ;
: 4sf  2sf 2sf 2swap ;

variable df
: 1df  df f! df 2@ ;

: 0e  ( - f: n )  STATE @ IF POSTPONE #0.0e ELSE #0.0e THEN ; immediate
: 1e  ( - f: n )  STATE @ IF POSTPONE #1.0e ELSE #1.0e THEN ; immediate

: 2s>f  swap s>f s>f ;  ( x y - f: x y )
: 3s>f  rot s>f swap s>f s>f ;  ( x y z - f: x y z )
: 4s>f  2swap 2s>f 2s>f ; 
: c>f   s>f 255e f/ ;  ( c - f: n )

: fValue  ( "name" - )
  Create f,   immediate does> state @ if s" literal f@ " evaluate exit then
  f@  ;

: fto   ( f: v - )
  ' >body  state @
  if   postpone literal
     postpone f!
  else f!
  then ; immediate

\ \ NOTE: these are not conversion routines, these are TRANSFER routines.  the numbers
\ \ returned on the data static are unusable except by DLL's.
\ 
\ : 2df  1df 2>r 1df 2r> ;  ( f: x y - ) ( s: float float )
\ 
\ : 3df  ( f: x y z - ) ( s: float float float )
\   1df 2>r 1df 2>r 1df 2r> 2r> ;
\ 
\ : 4df  ( f: x y z a - ) ( s: float float float float )
\   1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> ;
\ 
\ : 5df  ( f: x y z a b - ) ( s: float float float float float )
\   1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> 2r> ;
\ 
\ : 6df  ( f: x y z a b c - ) ( s: float float float float float float )
\   1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> 2r> 2r> ;
\ 
\ : 9df  ( f: x y z a b c d e f - ) ( s: float float float float float float float float float )
\   1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df
\   2r> 2r> 2r> 2r> 2r> 2r> 2r> 2r> ;

( tilemap vars )
var scrollx  var scrolly  \ used to define starting column and row!
var tbi                   \ tile base index


( main 1024x1024 tile buffer )
1024 1024 buffer2d: tilebuf 

: scroll  ( - adr ) scrollx 2@ 2dup 16 16 2mod 2negate +at  16 16 2/ tilebuf loc ;
: tilerow   dup for  @+ tile  16 0 +at  loop  1008 +a  -16 * 16 +at ;
: tilemap   scroll  a!>  16 for  17 tilerow  loop ;

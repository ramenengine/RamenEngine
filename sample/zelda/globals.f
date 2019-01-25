( global variables and savestate )

\ #16 quest-field player
2 cells quest-field coords  3 3 coords 2!
quest-var room#
\ quest-var world#
quest-var in-cave
quest-var tempx  quest-var tempy
\ object-maxsize quest-field linkstate
quest-var maxbombs  8 maxbombs !
quest-var maxpotions 1 maxpotions !

create roombuf %array2d struct,
    16  16  tilebuf pitch@  1( 0 0 tilebuf loc )  roombuf /array2d

16 constant #cols
11 constant #rows
0 value world          \ pointer to a %world

stage actor bg  
include sample/zelda/printer.f
stage actor cam 
stage actor hud  
stage actor minimap
stage actor link  
: p1  link ;

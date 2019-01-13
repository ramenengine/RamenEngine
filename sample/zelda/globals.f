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
    16  16  tilebuf pitch@  0 0 tilebuf loc  roombuf /array2d

16 constant #cols
11 constant #rows
0 value world          \ pointer to a %world
create bg object
include sample/zelda/printer.f
create cam object 
create hud object
create minimap object
create link object
: p1  link ;

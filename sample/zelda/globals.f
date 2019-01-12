( global variables and savestate )

\ #16 qfield player
2 cells qfield coords  3 3 coords 2!
qvar room#
\ qvar world#
qvar in-cave
qvar tempx  qvar tempy
\ object-maxsize qfield linkstate
qvar maxbombs  8 maxbombs !
qvar maxpotions 1 maxpotions !

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

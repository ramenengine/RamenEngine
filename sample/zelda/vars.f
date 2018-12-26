( global variables and savestate )

quest-ptr
    \ #16 qfield player
    2 cells qfield coords  3 3 coords 2!
    qvar room#
    \ qvar world#
    qvar in-cave
    qvar tempx  qvar tempy
    \ maxsize qfield linkstate

    qvar maxbombs  8 maxbombs !
    qvar maxpotions 1 maxpotions !
to quest-ptr


16 constant #cols
11 constant #rows
0 value world          \ pointer to a %world
create bg object 
create cam object 
create hud object
create minimap object
create link object
: p1  link ;

\ item types
1
enum #rupees
enum #sword
enum #bomb
enum #potion
drop

( global variables and savestate )

: qvar  dup constant cell+ ;
: qfield  over constant + ;

create quest  64 kbytes /allot
quest
    \ #16 qfield player
    2 cells qfield coords  3 3 coords 2!
    qvar room#
    \ qvar world#
    qvar in-cave
    qvar tempx  qvar tempy
    \ maxsize qfield linkstate    
drop


16 constant #cols
11 constant #rows
\ create coords 3 , 3 , 
\ variable room#
0 value world^
create bg object 
create cam object 
create hud object
create minimap object
create link object
: p1  link ;
\ variable in-cave
\ create tempx 0 , 0 ,

\ attributes
#1
bit #weapon
drop

\ item types
: enum  dup constant 1 + ;
1
enum #sword
enum #bomb
enum #potion
drop

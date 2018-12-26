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
0 value world          \ pointer to a %world
create bg object 
create cam object 
create hud object
create minimap object
create link object
: p1  link ;
defer important?  ( - flag )


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

\ object flags
var flags
#1
bit #important
drop
: flag?  flags @ and 0<> ;
: +flag  flags or! ;
: -flag  invert flags and! ;
:make important? ( - flag ) #important flag? ;

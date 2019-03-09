( flags ) nr
nextflag
    bit #weapon
    bit #inair
    \ bit #entrance
    \ bit #ground
    \ bit #fire
    \ bit #water
    bit #npc
    bit #item
    bit #enemy
drop

16 constant #cols
11 constant #rows
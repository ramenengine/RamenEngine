include ramen/ramen.f
empty
depend ramen/basic.f

0 0 viewwh middle at stage *actor as

:now  draw> red 64 circlef ;

: oscillate  ( n - )
    perform> 
    begin
        30 for  dup x +!  pause loop
        10 pauses
        negate
        30 for  dup x +!  pause loop
        10 pauses
        negate
    again
;

2 oscillate 
\ 4 oscillate 
\ 2 oscillate 

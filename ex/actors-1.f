include ramen/ramen.f
empty
depend ramen/basic.f

: /bubble  draw> lblue 64 globalscale / circlef ;

0 0 viewwh middle at stage *actor as 
/bubble

\ Now make the actor do something by calling act>:

: jitter  act> 2 2 2rnd 1 1 2- x 2+! ;

jitter

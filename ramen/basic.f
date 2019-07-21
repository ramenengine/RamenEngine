( Basic library set )

fixed
depend ramen/lib/std/actor.f     
depend ramen/lib/std/rangetools.f
depend ramen/lib/std/multi.f      
depend ramen/lib/std/v2d.f       
depend ramen/lib/std/kb.f        
depend ramen/lib/std/audio.f     
depend ramen/lib/std/sprites.f   
depend ramen/lib/std/transform.f 
depend ramen/lib/utils.f         

: show-stage  ( - ) show> ramenbg mount stage draws ;
show-stage 

: think  stage acts stage multi ;
: physics  stage each> as vx 2@ x 2+! ;
: default-step  step> think physics sweep ;
default-step

cr .( Finished loading the Basic packet. ) 
( Lite library set )

depend ramen/lib/std/actor.f       cr .( Loaded actors module... ) 
depend ramen/lib/std/rangetools.f  cr .( Loaded rangetools module. ) 
depend ramen/lib/std/task.f        cr .( Loaded task module. ) 
depend ramen/lib/std/v2d.f         cr .( Loaded vector2d module. ) 
depend ramen/lib/std/kb.f          cr .( Loaded keyboard lex. ) 
depend ramen/lib/std/audio.f       cr .( Loaded audio module. ) 
depend ramen/lib/std/sprites.f     cr .( Loaded sprites module. ) 
depend ramen/lib/array2d.f         cr .( Loaded array2d... ) 
depend ramen/lib/buffer2d.f        cr .( Loaded buffer2d... ) 
depend ramen/lib/utils.f           cr .( Loaded utils... ) 

: show-stage  ( - ) show> ramenbg mount stage draws ;
show-stage 

: think  stage acts stage multi ;
: physics  stage each> as vx 2@ x 2+! ;
: default-step  step> think physics sweep ;
default-step

cr .( Finished loading Lite pack. ) 
defer (startup)

: startup
    false to allegro?
    0 to display
    +display  initaudio initdata (startup)
    ." Test"
    ok ;


: gather
    assets> srcfile dup count s" data/" search if rot place else 3drop then ;

\ TODO: support for other systems
[defined] program [if]
: publish ( xt -- <name> )
    gather  is (startup)  ['] startup 'main !  program ;
[else]
cr .( PROGRAM not defined; PUBLISH disabled )
[then]
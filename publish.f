defer (startup)

: startup
    false to allegro?
    0 to display
    +display  initdata (startup)
    ." Test"
    ok ;


: gather ;

: publish ( xt -- <name> )
    gather  is (startup)  ['] startup 'main !  program ;

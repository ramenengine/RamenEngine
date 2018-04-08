defer (startup)

: startup
    false to allegro?
    0 to display
    +display  initdata (startup)
    ." Test"
    ok ;


: gather
    assets> srcfile dup count " data/" search if rot place else 3drop then ;

: publish ( xt -- <name> )
    gather  is (startup)  ['] startup 'main !  program ;

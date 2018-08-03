\ TODO: support for other systems

defer warm

: boot
    false to allegro?
    false to display
    false to dev
    #3 to #globalscale
    ALLEGRO_WINDOWED
    ALLEGRO_NOFRAME or
        to allegro-display-flags
    +display
    initaudio
    initdata
;

: startup
    boot
    warm
    ok
;


: gather
    assets> srcfile dup count s" data/" search if rot place else 3drop then ;

[defined] program [if]

    'main @ constant default-main
    
    :noname  0 ExitProcess ;  is bye
    
    : publish ( xt -- <name> )
        gather  is warm  ['] startup 'main !  program  default-main 'main ! ;
[else]
    cr .( PROGRAM not defined; PUBLISH disabled )
[then]
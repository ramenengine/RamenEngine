\ TODO: support for other systems

create default-font
    /assetheader /allot  al-default-font , 8 , 0 , \ note: not a registered asset

defer warm  :is warm ;

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
    al-default-font default-font font.fnt !
;

: runtime
    boot
    warm
    go
;


: gather
    assets> srcfile dup count s" data/" search if rot place else 3drop then ;

[defined] program [if]
    
    :noname  0 ExitProcess ;  is bye
    
    : publish ( -- <name> )
        cr ." Publishing to "  >in @  bl parse type >in !  ." .exe ... "
        gather
        'main @ >r
            ['] runtime 'main !
            program
        r> 'main ! ;
[else]
    cr .( PROGRAM not defined; PUBLISH disabled )
[then]
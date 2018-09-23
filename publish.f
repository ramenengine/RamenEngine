\ TODO: support for other systems

create default-font
    /assetheader /allot  al-default-font , 8 , 0 , \ note: not a registered asset

defer cold  :is cold ;   \ cold boot: executed once at runtime
defer warm  :is warm ;   \ warm boot: executed potentially multiple times 

: boot
    false to allegro?
    false to display
    #3 to #globalscale
    ALLEGRO_WINDOWED
    ALLEGRO_NOFRAME or
        to allegro-display-flags
    +display
    initaudio
    initdata
    al-default-font default-font font.fnt !
;
: runtime  boot cold warm go ;
: relify  srcfile dup count s" data/" search if  rot place  else 3drop then ;
: gather  assets> relify ;

[defined] program [if]
    
    :is bye  0 ExitProcess ; 
    
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
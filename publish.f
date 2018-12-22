\ TODO: support for other systems
    
create default-font
    /assetheader /allot  al-default-font , 8 , 0 , \ note: not a registered asset

defer cold  :make cold ;   \ cold boot: executed once at runtime
defer warm  :make warm ;   \ warm boot: executed potentially multiple times 

\ :make alert
\    zstring 

: boot
    false to allegro?
    false to display
    #3 to #globalscale
    ALLEGRO_WINDOWED
    ALLEGRO_NOFRAME or
        to allegro-display-flags
    +display
    initaudio
    ['] initdata catch if s" An asset failed to load." alert then
    al-default-font default-font font.fnt !
;
: runtime  boot cold warm go ;
: relify  srcfile dup count s" data/" search if  rot place  else 3drop then ;

[defined] program [if]
    
    :make bye  0 ExitProcess ; 
    
    : publish ( - <name> )
        cr ." Publishing to "  >in @  bl parse type >in !  ." .exe ... "
        ['] relify assets each
        ['] runtime 'main !
        program ;
[else]
    cr .( PROGRAM not defined; PUBLISH disabled )
[then]
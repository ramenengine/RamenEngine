( ---=== Publish: SwiftForth ===--- )

create default-font  \ note not a registered asset
    /assetheader /allot  al-default-font , 8 , 0 , 

defer cold  :make cold ;   \ cold boot: executed once at runtime
defer warm  :make warm ;   \ warm boot: executed potentially multiple times 

: gamewindow
    fs off
    ALLEGRO_WINDOWED
    ALLEGRO_OPENGL or
    al_set_new_display_flags ;

: boot
    false to allegro?
    #3 to #globalscale
    gamewindow
    scaled-res init-display
    al-default-font default-font font.fnt !
    project off
    oscursor off
    fixed
    ['] initdata catch if s" An asset failed to load." alert then
;

: kickoff
    boot cold warm go ;
    
: runtime
    kickoff bye ;

: relify
    dup asset? if srcfile dup count s" data/" search if  rot place  else 3drop then
               else drop then ;

[defined] program [if]
    
    : publish ( - <name> )
        cr ." Publishing to "  >in @ bl parse type >in !  ." .exe ... "
        ['] relify assets each
        ['] runtime 'main !
        program ;
        
[else]
    cr .( PROGRAM not defined; PUBLISH disabled )
[then]
( ---=== Publish: SwiftForth ===--- )

create default-font  \ note not a registered asset
    /assetheader /allot  al-default-font , 8 , 0 , 

defer cold  :make cold ;   \ cold boot: executed once at runtime
defer warm  :make warm ;   \ warm boot: executed potentially multiple times 

: boot
    false to allegro?
    fullscreen
    al-default-font default-font font.fnt !
    project off
    oscursor off
    fixed
    ['] initdata catch abort" An asset failed to load."
;

: kickoff  
    boot cold warm go ;

: runtime
    ['] kickoff ?alert bye ;

: relify
    dup asset? if srcfile dup count s" data/" search if  rot place  else 3drop then
               else drop then ;

[in-platform] sf [if]
  [defined] program [if]
      
      : publish ( - <name> )
          cr ." Publishing to "  >in @ bl parse type >in !  ." .exe ... "
          ['] relify assets each
          ['] runtime 'main !
          program
          >host
      ;
          
      : debug  ( - <name> )
          cr ." Publishing to "  >in @ bl parse type >in !  ." .exe (DEBUG) ..."
          ['] relify assets each
          ['] development 'main !
          program
          >host
      ;
          
  [else]
      cr .( PROGRAM not defined; PUBLISH disabled )
  [then]
[then]
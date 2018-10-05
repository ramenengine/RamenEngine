defasset font
    font int svar font.fnt
    font int svar font.size
    font int svar font.flags

: >fnt  font.fnt @ ;

: reload-font  ( font -- )
    >r  r@ srcfile count findfile zstring  r@ font.size @ 1i  r@ font.flags @  al_load_font  r> font.fnt ! ;

: init-font  ( path c size flags font -- )
    >r  r@ font.flags !  r@ font.size !
    r@ srcfile place  ['] reload-font r@ register  r> reload-font ;

: font:  ( path c size flags -- <name> )
    create  font sizeof allotment  init-font ;

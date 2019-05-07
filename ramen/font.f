asset: font
    font svar font.fnt
    font svar font.size
    font svar font.flags
: >fnt ( font - ALLEGRO_FONT ) font.fnt @ ;

: reload-font  ( font - )
    >r  r@ srcfile count findfile zstring  r@ font.size @ 1i  r@ font.flags @  al_load_font  r> font.fnt ! ;

: unload-font  ( font - )
    font.fnt @ al_destroy_font ;

: init-font  ( path c size flags font - )
    >r  r@ font.flags !  r@ font.size !
    r@ srcfile place  ['] reload-font ['] unload-font r@ register
    r> reload-font ;

: font:  ( path c size flags - <name> )
    create  font sizeof allotment  init-font ;

create (chr)  0 c, 0 c,
: chrw    ( font chr - n ) (chr) c!  >fnt (chr) al_get_text_width 1p ;
: chrh    ( font - n ) >fnt al_get_font_line_height 1p ;

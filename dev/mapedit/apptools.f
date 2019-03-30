#2 #0 #0 [ws] [checkver]

variable lb
variable rb
stage one :now act> ui on ;  \ workspace always on


: ?b  
    evt ALLEGRO_MOUSE_EVENT.button @ #1 = if lb ;then
    evt ALLEGRO_MOUSE_EVENT.button @ #2 = if rb ;then
;

: app-events
    etype ALLEGRO_EVENT_MOUSE_BUTTON_DOWN = if ?b on ;then
    etype ALLEGRO_EVENT_MOUSE_BUTTON_UP = if ?b off ;then
;

: maus   mouse 2@ globalscale dup 2/ ;

also wsing
    s" Test" label named mauser
    : (p.)  1pf #2 (f.) ;
    stage one
    :now act> maus swap (p.) s[ (p.) +s ]s mauser { data! } ;    
previous

: (dialog)
        al_create_native_file_dialog
        display over al_show_native_file_dialog if
            0 al_get_native_file_dialog_path zcount rot ( dest ) place
            \ count -filename 2dup type cwd drop
            true
        else
            drop drop
            false
        then
;

: ?wd  dup count dup if -filename zstring else 2drop zwd then  ;

: ossave  ( dest filter c - flag )
    lb off
    2>r  ?wd  z" Save"  2r> zstring
        ALLEGRO_FILECHOOSER_SAVE (dialog)
;

: osopen  ( dest filter c - flag )
    lb off
    2>r  ?wd  z" Open"  2r> zstring
        ALLEGRO_FILECHOOSER_FILE_MUST_EXIST (dialog)
;

: image-formats  s" *.png;*.jpg;*.bmp;*.gif;*.tif" ;

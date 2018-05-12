
variable mtime  \ last modified time
: loadbitmap  0 al_set_new_bitmap_flags    zstring al_load_bitmap ;
: art$  prjpath " /art.png" strjoin ;
: initgfx   art$ loadbitmap to art ;
: file>mtime  zstring al_create_fs_entry dup al_get_fs_entry_mtime swap al_destroy_fs_entry ;
: ?modified
    art$ file>mtime dup mtime @ <> if
        mtime !  r> drop
    exit then  drop ;
: updgfx   ?modified  art al_destroy_bitmap  art$ loadbitmap to art ;

[section] Updater
0 value updater   \ allegro timer

: +updater
    0.5e 1df al_create_timer to updater
    eventq updater al_get_timer_event_source al_register_event_source
    updater al_start_timer
;

: -updater
    eventq updater al_get_timer_event_source al_unregister_event_source
    updater al_destroy_timer
    0 to updater
;

: updater-events
    etype ALLEGRO_EVENT_DISPLAY_SWITCH_OUT = if  +updater  then
    etype ALLEGRO_EVENT_DISPLAY_SWITCH_IN = if  -updater then
    etype ALLEGRO_EVENT_TIMER = if
        evt ALLEGRO_EVENT.source @ updater = if  updgfx  then
    then
;

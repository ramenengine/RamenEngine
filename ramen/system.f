\ 2.0 system events extension

: ext-mouse
    etype ALLEGRO_EVENT_MOUSE_AXES = if
        repl? if
            evt ALLEGRO_MOUSE_EVENT.dz @ 0 > if ide:pageup ;then
            evt ALLEGRO_MOUSE_EVENT.dz @ 0 < if ide:pagedown ;then
        ;then
    ;then
;


: ext-kb
    etype ALLEGRO_EVENT_KEY_DOWN = keycode <f2> = and if
        page
        repl? if repl off else repl on then
    ;then 
;
: (system)  ext-kb  ext-mouse  ide-system  ;

also ideing
: ide  rasa  /repl  ['] (system) is ?system   ['] ?rest catch ?.catch  go  -ide ;
previous

marker (empty) 

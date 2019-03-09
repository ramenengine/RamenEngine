\ function: al_get_opengl_extension_list ( -- ALLEGRO_OGL_EXT_LIST )

[defined] linux [if]
    linux-library liballegro
    function: al_get_x_window_id ( display -- id )
    function: al_x_set_initial_icon ( bitmap -- bool )
[then]

function: al_show_native_message_box ( ALLEGRO_DISPLAY-*display, char-const-*title, char-const-*heading, char-const-*text, char-const-*buttons, int-flags -- )
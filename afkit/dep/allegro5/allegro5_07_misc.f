\ function: al_get_opengl_extension_list ( -- ALLEGRO_OGL_EXT_LIST )

[defined] linux [if]
    linux-library liballegro
    function: al_get_x_window_id ( display -- id )
    function: al_x_set_initial_icon ( bitmap -- bool )
[then]
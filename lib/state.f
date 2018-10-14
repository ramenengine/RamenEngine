create states  /ALLEGRO_STATE 16 * allot
variable >state

: (state)  >state @ 15 and  /ALLEGRO_STATE *  states + ;

: +state  (state) ALLEGRO_STATE_TARGET_BITMAP
                  ALLEGRO_STATE_DISPLAY                 or
                  ALLEGRO_STATE_BLENDER                 or
                  ALLEGRO_STATE_NEW_FILE_INTERFACE      or
                  ALLEGRO_STATE_TRANSFORM               or
                  ALLEGRO_STATE_PROJECTION_TRANSFORM    or  al_store_state
            1 >state +!
;

: -state  -1 >state +!  (state) al_restore_state ;
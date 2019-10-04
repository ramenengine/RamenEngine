include afkit/ans/version.f
#1 #6 #0 [version] [afkit]

\ Load external libraries
[undefined] EXTERNALS_LOADED [if]  \ ensure that external libs are only ever loaded once.
    s" \kitconfig.f" file-exists [if]
        include \kitconfig.f
    [else]
      s" kitconfig.f" file-exists [if]
        include kitconfig.f
      [else]
        s" Missing kitconfig.f!!! " type QUIT
      [then]
    [then]
    include afkit/platforms.f

    true constant EXTERNALS_LOADED

    : empty  only forth definitions s" (empty) marker (empty)" evaluate ;
    marker (empty)
[then]

\ Load support libraries
include afkit/plat/win/fpext.f      \ depends on FPMATH
include afkit/ans/strops.f         \ ANS
include afkit/ans/files.f          \ ANS
include afkit/ans/roger.f          \ ANS

[defined] allegro-audio [if]  include afkit/audio-allegro.f  [then]

\ --------------------------------------------------------------------------------------------------
0 value al-default-font
0 value fps
0 value allegro?
0 value eventq
0 value display
create uesrc 32 cells /allot
variable fs    \  enables fullscreen when on
1 value #globalscale
create res  0 , 0 ,
defer >host
_AL_MAX_JOYSTICK_STICKS constant MAX_STICKS
create joysticks   MAX_STICKS /ALLEGRO_JOYSTICK_STATE * /allot
16 cells constant /transform
/ALLEGRO_KEYBOARD_STATE 17 * constant /kstates
create kbstate  /kstates /allot \ current frame's state (* 17 inputs)
create kblast  /kstates /allot  \ last frame's state
create penx  0 ,  here 0 ,  constant peny
0 value oldblender
0 value currentblender
0 constant FLIP_NONE
1 constant FLIP_H
2 constant FLIP_V
3 constant FLIP_HV

\ --------------------------------------------------------------------------------------------------
\ Initializing Allegro and creating the display window

: init-allegro-all
  al_init 0= abort" Couldn't initialize Allegro."  
  al_init_image_addon 0= abort" Allegro: Couldn't initialize image addon." 
  al_init_primitives_addon 0= abort" Allegro: Couldn't initialize primitives addon."
  al_init_font_addon 0= abort" Allegro: Couldn't initialize font addon." 
  al_init_ttf_addon 0= abort" Allegro: Couldn't initialize TTF addon."
  al_install_mouse 0= abort" Allegro: Couldn't initialize mouse." 
  al_install_keyboard 0= abort" Allegro: Couldn't initialize keyboard."
  al_install_joystick 0= abort" Allegro: Couldn't initialize joystick."
  al_init_native_dialog_addon 0= abort" Allegro: Couldn't initialize native dialogs."
;

\ ------------------------------------ initializing the display ------------------------------------

: assertAllegro ( - ) 
    allegro? ?exit   true to allegro?  init-allegro-all
    [defined] allegro-audio [if]  initaudio  [then]
; 

: xy@ ( adr - x y )  dup @ swap cell+ @ ;
: x@ ( adr - x ) xy@ drop ;
: y@ ( adr - y ) xy@ nip ;

: displayw  ( - n ) display al_get_display_width ;
: displayh  ( - n ) display al_get_display_height ;
: displaywh ( - w h ) displayw displayh ;

: init-display  ( w h - )
    assertAllegro
    fs @ if 2drop -1 -1 then
    locals| h w | 

    ALLEGRO_DEPTH_SIZE #24 ALLEGRO_SUGGEST  al_set_new_display_option
    ALLEGRO_VSYNC 1 ALLEGRO_SUGGEST  al_set_new_display_option

    w h al_create_display  to display
    res 2@ or 0= if  displaywh res 2!  then

    \ 0 native al_get_monitor_info 0= abort" Couldn't get monitor info; try replugging the monitor or restarting"
    
    display al_get_display_refresh_rate dup 0= if drop 60 then to fps

    al_create_builtin_font to al-default-font

    al_create_event_queue  to eventq
    eventq  display       al_get_display_event_source  al_register_event_source
    eventq                al_get_mouse_event_source    al_register_event_source
    eventq                al_get_keyboard_event_source al_register_event_source
    uesrc al_init_user_event_source
    eventq                uesrc                        al_register_event_source

    ALLEGRO_DEPTH_TEST 0 al_set_render_state
;

: valid?  ( adr - flag ) ['] @ catch nip 0 = ;
: scaled-res  ( - w h ) res x@ #globalscale * res y@ #globalscale * ;
: +display  ( - ) display valid? ?exit  scaled-res init-display ;
: -display  ( - ) display valid? -exit
    display al_destroy_display  0 to display
    eventq al_destroy_event_queue  0 to eventq ;
: -allegro  ( - ) -display  false to allegro?  al_uninstall_system ;
: resolution  ( w h - ) res 2!  fs @ 0= if  -display  +display  then ;

\ ----------------------------------- words for switching windows ----------------------------------
[defined] linux [if]
    variable _hwnd
    variable _disp

    0 XOpenDisplay _disp !
    _disp @ _hwnd here XGetInputFocus

    : HWND  ( - handle ) _hwnd @ ;

    : btf ( window - )
        0 XOpenDisplay _disp !
        _disp @ over 0 0 XSetInputFocus
        _disp @ swap XRaiseWindow
        _disp @ 0 XSync ;

    : >display ( - )
        display al_get_x_window_id focus ;
[else]
    : btf  ( winapi-window - )
        dup 1 ShowWindow drop  dup BringWindowToTop drop  SetForegroundWindow drop ;
    : >display  ( - )
        display al_get_win_window_handle btf ;
[then]

:make >host HWND btf ;

create (wd) #512 allot
: zwd  ( - zadr )  al_get_current_directory zcount (wd) zplace  (wd) ;
: cwd  ( adr c - flag )  (wd) zplace   (wd) al_change_directory 0<> ;

\ ----------------------------------------------- keyboard -----------------------------------------

: pollKB  ( - )
    kbstate kblast /ALLEGRO_KEYBOARD_STATE move
    kbstate al_get_keyboard_state ;

: clearkb  ( - )
    kblast /kstates erase
    kbstate /kstates erase ;

: resetkb  ( - )
    clearkb
    al_uninstall_keyboard
    al_install_keyboard  not abort" Error re-establishing the keyboard :/"
    eventq  al_get_keyboard_event_source al_register_event_source ;

\ ----------------------------------------- end keyboard -------------------------------------------
\ ----------------------------------------- joysticks ----------------------------------------------
\ NTS: we don't handle connecting/disconnecting devices yet,
\   though Allegro 5 /does/ support it. (via an event)

: joy[] ( n - adr ) /ALLEGRO_JOYSTICK_STATE *  joysticks + ;
: >joyhandle ( n - ALLEGRO_JOYSTICK_STATE ) al_get_joystick ;
: stick  ( joy# stick# - f: x y )  \ get stick position
  /ALLEGRO_JOYSTICK_STATE_STICK *  swap joy[]
  ALLEGRO_JOYSTICK_STATE.sticks + dup sf@ cell+ sf@ ;
: btn  ( joy# button# - n# )  \ get button state
  cells swap joy[] ALLEGRO_JOYSTICK_STATE.buttons + @ ;
: #joys ( - n ) al_get_num_joysticks ;
: pollJoys ( - )  #joys for  i >joyhandle i joy[] al_get_joystick_state  loop ;
\ ----------------------------------------- end joysticks ------------------------------------------

\ --------------------------------------------------------------------------------------------------
\ Graphics essentials; no-fixed-point version
: transform:  create  here  /transform allot  al_identity_transform ;
transform: (identity)

\ integer stuff
: bmpw   ( bmp - n )  al_get_bitmap_width  ;
: bmph   ( bmp - n )  al_get_bitmap_height  ;
: bmpwh  ( bmp - w h )  dup bmpw swap bmph ;
: hold>  ( - <code> )  1 al_hold_bitmap_drawing  r> call  0 al_hold_bitmap_drawing ;
: loadbmp  ( adr c - bmp )
    zstring dup al_load_bitmap dup 0 = if
      cr zcount type
      true abort" AFKit: Error loading a bitmap." 
    else
      nip
    then
;
: savebmp  ( bmp adr c - )
    zstring dup rot al_save_bitmap 0 = if
      cr zcount type
      true abort" AFKit: Error saving a bitmap."
    else
      drop
    then
;
: -bmp  ( bmp - )  ?dup -exit al_destroy_bitmap ;

create write-src  ALLEGRO_ADD , ALLEGRO_ONE   , ALLEGRO_ZERO          , ALLEGRO_ADD , ALLEGRO_ONE , ALLEGRO_ZERO , 
create add-src    ALLEGRO_ADD , ALLEGRO_ALPHA , ALLEGRO_ONE           , ALLEGRO_ADD , ALLEGRO_ONE , ALLEGRO_ONE  , 
create interp-src ALLEGRO_ADD , ALLEGRO_ALPHA , ALLEGRO_INVERSE_ALPHA , ALLEGRO_ADD , ALLEGRO_ONE , ALLEGRO_ONE  , 

: blend  ( blender - ) 
    dup to currentblender
    @+ swap @+ swap @+ swap @+ swap @+ swap @ al_set_separate_blender ;
: blend>  ( blender - ) 
    currentblender to oldblender  blend  r> call  oldblender blend ;
interp-src blend

\ Pen
: at   ( x y - )  penx 2! ;
: +at  ( x y - )  penx 2+! ;
: at@  ( - x y )  penx 2@ ;

\ State
define internal
  create states  /ALLEGRO_STATE 16 * allot
  variable >state
  : (state)  >state @ 15 and  /ALLEGRO_STATE *  states + ;
using internal
: +state  ( - ) (state) ALLEGRO_STATE_TARGET_BITMAP
                  ALLEGRO_STATE_DISPLAY                 or
                  ALLEGRO_STATE_BLENDER                 or
                  ALLEGRO_STATE_NEW_FILE_INTERFACE      or
                  ALLEGRO_STATE_TRANSFORM               or
                  ALLEGRO_STATE_PROJECTION_TRANSFORM    or  al_store_state
            1 >state +!
;
: -state  ( - ) -1 >state +!  (state) al_restore_state ;
previous

: fullscreen
    fs on
    \ [defined] dev [if] ALLEGRO_FULLSCREEN_WINDOW [else] ALLEGRO_FULLSCREEN [then]
    ALLEGRO_FULLSCREEN_WINDOW 
    ALLEGRO_OPENGL or
    al_set_new_display_flags
    +display
;

fullscreen


( -=- Dialog box errors -=- )

: error  ( message count - )
    zstring >r  display z" Error" z" "  r>  z" Shoot" ALLEGRO_MESSAGEBOX_ERROR
        al_show_native_message_box drop ;

[defined] dev [in-platform] sf and [if]
  : softcatch  ( xt - ) catch ?dup if cr (THROW) type then ;
[else]
  : softcatch  ( xt - ) catch throw ;
[then]

[in-platform] sf [if]
  : ?alert  ( xt - ) catch ?dup if (THROW) error then ;
[else]
  : ?alert  ( xt - ) softcatch ;
[then]

\ --------------------------------------------------------------------------------------------------
include afkit/piston.f
\ --------------------------------------------------------------------------------------------------

>host

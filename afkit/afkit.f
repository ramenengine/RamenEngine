include afkit/ans/version.f
#1 #5 #9 [version] [afkit]

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

    [undefined] LIGHTWEIGHT [if]
        cd afkit/ans/ffl
            ffling +order
                include ffl/dom.fs
                include ffl/b64.fs
            ffling -order
        cd ../../..
    [then]

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
[defined] initial-scale [if] initial-scale [else] 1 [then] value #globalscale
[undefined] initial-res [if]  : initial-res  640 480 ;  [then]
[undefined] initial-pos [if]  : initial-pos  0 0 ;  [then]
create res  initial-res swap , ,
defer >ide
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
  al_init
    not if  s" Couldn't initialize Allegro." alert     -1 abort then
  al_init_image_addon
    not if  s" Allegro: Couldn't initialize image addon." alert      -1 abort then
  al_init_primitives_addon
    not if  s" Allegro: Couldn't initialize primitives addon." alert -1 abort then
  al_init_font_addon
    not if  s" Allegro: Couldn't initialize font addon." alert       -1 abort then
  al_init_ttf_addon
    not if  s" Allegro: Couldn't initialize TTF addon." alert       -1 abort then
  al_install_mouse
    not if  s" Allegro: Couldn't initialize mouse." alert            -1 abort then
  al_install_keyboard
    not if  s" Allegro: Couldn't initialize keyboard." alert         -1 abort then
  al_install_joystick
    not if  s" Allegro: Couldn't initialize joystick." alert         -1 abort then
;

create native  /ALLEGRO_MONITOR_INFO /allot
: nativewh  ( - w h )  native 2 cells + 2@ native 2@ 2- ;
: nativew  ( - n ) nativewh drop ;
: nativeh  ( - n ) nativewh nip ;

\ ------------------------------------ initializing the display ------------------------------------

: windowed
    fs off
    ALLEGRO_WINDOWED
    ALLEGRO_RESIZABLE or
    ALLEGRO_OPENGL or
    al_set_new_display_flags ;
windowed

: fullscreen
    fs on
    ALLEGRO_FULLSCREEN_WINDOW
    ALLEGRO_OPENGL or
    al_set_new_display_flags ;

: assertAllegro ( - ) 
    allegro? ?exit   true to allegro?  init-allegro-all
    0 native al_get_monitor_info 0= abort" Couldn't get monitor info; try replugging the monitor or restarting"
    [defined] allegro-audio [if]  initaudio  [then]
; 

: xy@ ( adr - x y )  dup @ swap cell+ @ ;
: x@ ( adr - x ) xy@ drop ;
: y@ ( adr - y ) xy@ nip ;

: displayw  ( - n ) display al_get_display_width ;
: displayh  ( - n ) display al_get_display_height ;
: displaywh ( - w h ) displayw displayh ;

: init-display  ( w h - )
    locals| h w |
    assertAllegro

    ALLEGRO_DEPTH_SIZE #24 ALLEGRO_SUGGEST  al_set_new_display_option
    ALLEGRO_VSYNC 1 ALLEGRO_SUGGEST  al_set_new_display_option

    [defined] dev [if]
        fs @ if  0 0  else  initial-pos 40 +  then  al_set_new_window_position
        w h al_create_display  to display    
        fs @ 0= if   display initial-pos al_set_window_position  then
    [else]
        \ centered:
        fs @ if  0 0 al_set_new_window_position  else  
            nativew 2 / w 2 / - nativeh 2 / h 2 / - 40 - al_set_new_window_position
        then
        w h al_create_display  to display    
    [then]
    
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

:make >ide HWND btf ;
>ide

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

: joystick[] ( n - adr ) /ALLEGRO_JOYSTICK_STATE *  joysticks + ;
: >joyhandle ( n - ALLEGRO_JOYSTICK_STATE ) al_get_joystick ;
: stick  ( joy# stick# - f: x y )  \ get stick position
  /ALLEGRO_JOYSTICK_STATE_STICK *  swap joystick[]
  ALLEGRO_JOYSTICK_STATE.sticks + dup sf@ cell+ sf@ ;
: btn  ( joy# button# - n# )  \ get button state
  cells swap joystick[] ALLEGRO_JOYSTICK_STATE.buttons + @ ;
: #joys ( - n ) al_get_num_joysticks ;
: pollJoys ( - )  #joys for  i >joyhandle i joystick[] al_get_joystick_state  loop ;
\ ----------------------------------------- end joysticks ------------------------------------------

\ --------------------------------------------------------------------------------------------------
\ Graphics essentials; no-fixed-point version
: transform:  create  here  /transform allot  al_identity_transform ;
transform: (identity)
: 0transform  (identity) swap /transform move ;

\ integer stuff
: bmpw   ( bmp - n )  al_get_bitmap_width  ;
: bmph   ( bmp - n )  al_get_bitmap_height  ;
: bmpwh  ( bmp - w h )  dup bmpw swap bmph ;
: hold>  ( - <code> )  1 al_hold_bitmap_drawing  r> call  0 al_hold_bitmap_drawing ;
: loadbmp  ( adr c - bmp ) zstring al_load_bitmap ;
: savebmp  ( bmp adr c - ) zstring swap al_save_bitmap 0= abort" Allegro: Error saving bitmap." ;
: -bmp  ?dup -exit al_destroy_bitmap ;

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

windowed  +display 
\ --------------------------------------------------------------------------------------------------
include afkit/piston.f
\ --------------------------------------------------------------------------------------------------

>ide

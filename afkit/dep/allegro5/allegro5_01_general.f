decimal \ important

\ window stuff
function: al_set_new_window_position ( int-x int-y -- )
function: al_set_window_position ( ALLEGRO_DISPLAY-*display int-x int-y -- )
function: al_get_window_position ( ALLEGRO_DISPLAY-*display *int-x *int-y -- )
function: al_set_new_display_adapter ( int-adapter -- )

\ monitor stuff - note, you have to load bitmaps twice AFAIK, using
\   al_set_target_backbuffer.  ??? not sure what I meant here
function: al_get_num_video_adapters ( -- n )
function: al_get_monitor_info ( adapter-id ALLEGRO_MONITOR_INFO_*info -- bool )
function: al_get_new_display_adapter ( -- adapter-id )

0
cvar x1
cvar y1
cvar x2
cvar y2
constant /ALLEGRO_MONITOR_INFO

function: al_install_system ( ver atexit -- bool ) \ (int version int (*atexit_ptr)((*)(void))));
function: al_uninstall_system ( -- )
: al_init    ALLEGRO_VERSION_INT 0 al_install_system ;
function: al_inhibit_screensaver ( bool -- )
function: al_get_errno ( -- int )

0
enum   ALLEGRO_RESOURCES_PATH
enum   ALLEGRO_TEMP_PATH
enum   ALLEGRO_USER_DATA_PATH
enum   ALLEGRO_USER_HOME_PATH
enum   ALLEGRO_USER_SETTINGS_PATH
enum   ALLEGRO_USER_DOCUMENTS_PATH
enum   ALLEGRO_EXENAME_PATH
enum   ALLEGRO_LAST_PATH \ must be last
drop

function: al_get_standard_path ( id -- ALLEGRO_PATH )

0
cvar drive
cvar filename
4 cells + \ cvar segments
cvar basename
cvar full_string
constant /ALLEGRO_PATH

: ucount  dup @ swap 2 cells + @ ;


\ mouse
#define ALLEGRO_MOUSE_MAX_EXTRA_AXES   4

\ mouse state
0
cvar ALLEGRO_MOUSE_STATE.x
cvar ALLEGRO_MOUSE_STATE.y
cvar ALLEGRO_MOUSE_STATE.z
cvar ALLEGRO_MOUSE_STATE.w
cvar ALLEGRO_MOUSE_STATE.more_axis1
cvar ALLEGRO_MOUSE_STATE.more_axis2
cvar ALLEGRO_MOUSE_STATE.more_axis3
cvar ALLEGRO_MOUSE_STATE.more_axis4
cvar ALLEGRO_MOUSE_STATE.buttons
cvar ALLEGRO_MOUSE_STATE.pressure  \ float
cvar ALLEGRO_MOUSE_STATE.display
constant /ALLEGRO_MOUSE_STATE

function: al_install_mouse ( -- bool )
function: al_uninstall_mouse ( -- )
function: al_get_mouse_state  ( ALLEGRO_MOUSE_STATE.*ret_state -- )
function: al_mouse_button_down  ( const-ALLEGRO_MOUSE_STATE.*state int-button -- bool )
function: al_get_mouse_state_axis ( const-ALLEGRO_MOUSE_STATE.*state int-axis -- val )
function: al_show_mouse_cursor ( struct-ALLEGRO_DISPLAY-*display -- )
function: al_hide_mouse_cursor ( struct-ALLEGRO_DISPLAY-*display -- )
function: al_grab_mouse ( struct-ALLEGRO_DISPLAY-*display -- )
function: al_ungrab_mouse ( -- )

function: al_get_mouse_event_source ( -- source )

\ keyboard
32 cell+ constant /ALLEGRO_KEYBOARD_STATE
function: al_install_keyboard ( -- bool )
function: al_uninstall_keyboard ( -- )
function: al_get_keyboard_state ( ALLEGRO_KEYBOARD_STATE.*ret_state -- )
function: al_key_down        ( const-ALLEGRO_KEYBOARD_STATE.* int-keycode -- bool )
function: al_set_keyboard_leds ( int-leds -- bool )

function: al_get_keyboard_event_source ( -- source )

\ joystick
/* internal values */
#define _AL_MAX_JOYSTICK_AXES   3
#define _AL_MAX_JOYSTICK_STICKS   16
#define _AL_MAX_JOYSTICK_BUTTONS  32

function: al_get_joystick_event_source ( -- source )

_AL_MAX_JOYSTICK_AXES cells constant /ALLEGRO_JOYSTICK_STATE_STICK  \ floats

0
  /ALLEGRO_JOYSTICK_STATE_STICK _AL_MAX_JOYSTICK_STICKS * cfield ALLEGRO_JOYSTICK_STATE.sticks
  _AL_MAX_JOYSTICK_BUTTONS cells cfield ALLEGRO_JOYSTICK_STATE.buttons
constant /ALLEGRO_JOYSTICK_STATE

function:        al_get_num_joysticks  ( -- n )
function:        al_install_joystick ( -- bool )
function:        al_get_joystick   ( int-joyn -- ALLEGRO_JOYSTICK-* )
function:        al_release_joystick   ( ALLEGRO_JOYSTICK-* -- )
function:        al_get_joystick_state  ( ALLEGRO_JOYSTICK-* ALLEGRO_JOYSTICK_STATE.*ret_state -- )

\ display
/* Possible bit combinations for the flags parameter of al_create_display. */
#define  ALLEGRO_WINDOWED               1 0 lshift
#define  ALLEGRO_FULLSCREEN             1 1 lshift
#define  ALLEGRO_OPENGL                 1 2 lshift
#define  ALLEGRO_DIRECT3D_INTERNAL      1 3 lshift
#define  ALLEGRO_RESIZABLE              1 4 lshift
#define  ALLEGRO_NOFRAME                1 5 lshift
#define  ALLEGRO_GENERATE_EXPOSE_EVENTS 1 6 lshift
#define  ALLEGRO_OPENGL_3_0             1 7 lshift
#define  ALLEGRO_OPENGL_FORWARD_COMPATIBLE   1 8 lshift
#define  ALLEGRO_FULLSCREEN_WINDOW      1 9 lshift
#define  ALLEGRO_MINIMIZED              1 10 lshift
#define  ALLEGRO_PROGRAMMABLE_PIPELINE  1 11 lshift
#define  ALLEGRO_GTK_TOPLEVEL_INTERNAL  1 12 lshift
#define  ALLEGRO_MAXIMIZED              1 13 lshift
#define  ALLEGRO_OPENGL_ES_PROFILE      1 14 lshift

\ /* Possible parameters for al_set_display_option.
\  * Make sure to update ALLEGRO_EXTRA_DISPLAY_SETTINGS if you modify
\  * anything here.
\  */
0
enum ALLEGRO_RED_SIZE
enum ALLEGRO_GREEN_SIZE
enum ALLEGRO_BLUE_SIZE
enum ALLEGRO_ALPHA_SIZE
enum ALLEGRO_RED_SHIFT
enum ALLEGRO_GREEN_SHIFT
enum ALLEGRO_BLUE_SHIFT
enum ALLEGRO_ALPHA_SHIFT
enum ALLEGRO_ACC_RED_SIZE
enum ALLEGRO_ACC_GREEN_SIZE
enum ALLEGRO_ACC_BLUE_SIZE
enum ALLEGRO_ACC_ALPHA_SIZE
enum ALLEGRO_STEREO
enum ALLEGRO_AUX_BUFFERS
enum ALLEGRO_COLOR_SIZE
enum ALLEGRO_DEPTH_SIZE
enum ALLEGRO_STENCIL_SIZE
enum ALLEGRO_SAMPLE_BUFFERS
enum ALLEGRO_SAMPLES
enum ALLEGRO_RENDER_METHOD
enum ALLEGRO_FLOAT_COLOR
enum ALLEGRO_FLOAT_DEPTH
enum ALLEGRO_SINGLE_BUFFER
enum ALLEGRO_SWAP_METHOD
enum ALLEGRO_COMPATIBLE_DISPLAY
enum ALLEGRO_UPDATE_DISPLAY_REGION
enum ALLEGRO_VSYNC
enum ALLEGRO_MAX_BITMAP_SIZE
enum ALLEGRO_SUPPORT_NPOT_BITMAP
enum ALLEGRO_CAN_DRAW_INTO_BITMAP
enum ALLEGRO_SUPPORT_SEPARATE_ALPHA
drop

0
enum   ALLEGRO_DONTCARE
enum   ALLEGRO_REQUIRE
enum   ALLEGRO_SUGGEST
drop

function: al_create_display ( int-w int-h -- display )
function: al_destroy_display ( ALLEGRO_DISPLAY-*display -- )
function: al_get_backbuffer  ( ALLEGRO_DISPLAY-*display -- bitmap )
function: al_get_display_refresh_rate  ( ALLEGRO_DISPLAY-*display -- n )

function: al_resize_display    ( ALLEGRO_DISPLAY-*display int-width int-height -- bool )
function: al_flip_display     ( -- )
function: al_update_display_region ( int-x int-y int-width int-height -- )
function: al_wait_for_vsync ( -- )
[undefined] linux [if]
    function: al_get_win_window_handle ( ALLEGRO_DISPLAY-*display -- hwnd )
[then]

function: al_set_new_display_option ( int-option, int-value, int-importance -- )
function: al_set_new_display_flags ( int-flags -- )
function: al_get_new_display_flags ( -- n )
function: al_set_window_title ( display name -- )

\ addon: native dialogs
#define  ALLEGRO_FILECHOOSER_FILE_MUST_EXIST  1
#define  ALLEGRO_FILECHOOSER_SAVE         2
#define  ALLEGRO_FILECHOOSER_FOLDER        4
#define  ALLEGRO_FILECHOOSER_PICTURES      8
#define  ALLEGRO_FILECHOOSER_SHOW_HIDDEN    16
#define  ALLEGRO_FILECHOOSER_MULTIPLE      32
#define  ALLEGRO_MESSAGEBOX_WARN          1 0 lshift
#define  ALLEGRO_MESSAGEBOX_ERROR         1 1 lshift
#define  ALLEGRO_MESSAGEBOX_OK_CANCEL      1 2 lshift
#define  ALLEGRO_MESSAGEBOX_YES_NO        1 3 lshift
#define  ALLEGRO_MESSAGEBOX_QUESTION       1 4 lshift
#define  ALLEGRO_TEXTLOG_NO_CLOSE         1 0 lshift
#define  ALLEGRO_TEXTLOG_MONOSPACE        1 1 lshift
#define  ALLEGRO_EVENT_NATIVE_DIALOG_CLOSE   600

linux-library liballegro_dialog
function: al_create_native_file_dialog ( char-const-*initial_path char-const-*title char-const-*patterns int-mode -- dialog )
function: al_show_native_file_dialog ( ALLEGRO_DISPLAY-*display ALLEGRO_FILECHOOSER-*dialog -- bool )
function: al_get_native_file_dialog_count ( const-ALLEGRO_FILECHOOSER-*dialog -- int )
function: al_get_native_file_dialog_path ( const-ALLEGRO_FILECHOOSER-*dialog size_t-index -- addr )
function: al_destroy_native_file_dialog ( ALLEGRO_FILECHOOSER-*dialog -- )
function: al_show_native_message_box ( ALLEGRO_DISPLAY-*display char-const-*title char-const-*heading char-const-*text char-const-*buttons int-flags -- int )
function: al_open_native_text_log ( char-const-*title int-flags -- log )
function: al_close_native_text_log ( ALLEGRO_TEXTLOG-*textlog -- )
\ function: al_append_native_text_log ( ALLEGRO_TEXTLOG-*textlog char-const-*format ... -- )
\ function: al_get_native_text_log_event_source ( ALLEGRO_TEXTLOG-*textlog -- source )

\ fullscreen stuff
function: al_get_num_display_modes ( -- n )
function: al_get_display_mode ( n data -- )

0
cvar width          \ Screen width
cvar height         \ Screen height
cvar format         \ The pixel format of the mode
cvar refresh_rate   \ The refresh rate of the mode
constant /ALLEGRO_DISPLAY_MODE


\ display object stuff
function: al_get_display_flags ( display -- n )
function: al_set_display_flag ( display flag bool -- f )
function: al_get_display_width ( display -- w )
function: al_get_display_height ( display -- h )

\ thread stuff
function: al_create_thread ( proc arg -- thread )
function: al_start_thread ( thread -- )
function: al_destroy_thread ( thread -- )
function: al_join_thread ( thread &retval -- )
function: al_set_thread_should_stop ( thread -- )
function: al_run_detached_thread ( callback &arg -- )
function: al_create_mutex ( -- mutex )
function: al_create_mutex_recursive ( -- mutex )
function: al_lock_mutex ( mutex -- )
function: al_unlock_mutex ( mutex -- )
function: al_destroy_mutex ( mutex -- )
function: al_create_cond ( -- cond )
function: al_destroy_cond ( cond -- )
function: al_wait_cond ( cond mutex -- )
function: al_wait_cond_until ( cond mutex timeout-struct -- )
function: al_broadcast_cond ( cond -- )
function: al_signal_cond ( cond -- )

\ timer stuff
function: al_create_timer ( n n -- timer )
function: al_start_timer ( timer -- )
function: al_stop_timer ( timer -- )
function: al_destroy_timer ( timer -- )
function: al_get_timer_event_source ( timer -- source )
function: al_set_timer_count ( timer d d -- )
function: al_get_timer_started ( timer -- f )

function: al_get_display_event_source ( display -- source )

linux-library liballegro_memfile

function: al_open_memfile ( void-*mem, int64_t size, const-char-*mode -- ALLEGRO_FILE )
function: al_fclose ( ALLEGRO_FILE-*f -- )

decimal \ important

1  constant  ALLEGRO_EVENT_JOYSTICK_AXIS
2  constant  ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN
3  constant  ALLEGRO_EVENT_JOYSTICK_BUTTON_UP
4  constant  ALLEGRO_EVENT_JOYSTICK_CONFIGURATION
10 constant  ALLEGRO_EVENT_KEY_DOWN
11 constant  ALLEGRO_EVENT_KEY_CHAR
12 constant  ALLEGRO_EVENT_KEY_UP
20 constant  ALLEGRO_EVENT_MOUSE_AXES
21 constant  ALLEGRO_EVENT_MOUSE_BUTTON_DOWN
22 constant  ALLEGRO_EVENT_MOUSE_BUTTON_UP
23 constant  ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY
24 constant  ALLEGRO_EVENT_MOUSE_LEAVE_DISPLAY
25 constant  ALLEGRO_EVENT_MOUSE_WARPED
30 constant  ALLEGRO_EVENT_TIMER
40 constant  ALLEGRO_EVENT_DISPLAY_EXPOSE
41 constant  ALLEGRO_EVENT_DISPLAY_RESIZE
42 constant  ALLEGRO_EVENT_DISPLAY_CLOSE
43 constant  ALLEGRO_EVENT_DISPLAY_LOST
44 constant  ALLEGRO_EVENT_DISPLAY_FOUND
45 constant  ALLEGRO_EVENT_DISPLAY_SWITCH_IN
46 constant  ALLEGRO_EVENT_DISPLAY_SWITCH_OUT
47 constant  ALLEGRO_EVENT_DISPLAY_ORIENTATION
48 constant  ALLEGRO_EVENT_DISPLAY_HALT_DRAWING
49 constant  ALLEGRO_EVENT_DISPLAY_RESUME_DRAWING
50 constant  ALLEGRO_EVENT_TOUCH_BEGIN
51 constant  ALLEGRO_EVENT_TOUCH_END
52 constant  ALLEGRO_EVENT_TOUCH_MOVE
53 constant  ALLEGRO_EVENT_TOUCH_CANCEL
60 constant  ALLEGRO_EVENT_DISPLAY_CONNECTED
61 constant  ALLEGRO_EVENT_DISPLAY_DISCONNECTED
\ /*
\ * Event structures
\ *
\ * All event types have the following cfields in common.
\ *
\ *  type      -- the type of event this is
\ *  timestamp -- when this event was generated
\ *  source    -- which event source generated this event
\ *
\ * For people writing event sources: The common cfields must be at the
\ * very start of each event structure, i.e. put _AL_EVENT_HEADER at the
\ * front.
\ */

\ #define _AL_EVENT_HEADER( srctype)

0
   cvar ALLEGRO_EVENT.type
   cvar ALLEGRO_EVENT.source
   2 cells cfield ALLEGRO_EVENT.timestamp
constant /ALLEGRO_ANY_EVENT

/ALLEGRO_ANY_EVENT
   cvar ALLEGRO_DISPLAY_EVENT.x
   cvar ALLEGRO_DISPLAY_EVENT.y
   cvar ALLEGRO_DISPLAY_EVENT.width
   cvar ALLEGRO_DISPLAY_EVENT.height
   cvar ALLEGRO_DISPLAY_EVENT.orientation
constant /ALLEGRO_DISPLAY_EVENT


/ALLEGRO_ANY_EVENT
   cvar ALLEGRO_JOYSTICK_EVENT.*id
   cvar ALLEGRO_JOYSTICK_EVENT.stick
   cvar ALLEGRO_JOYSTICK_EVENT.axis
   cvar ALLEGRO_JOYSTICK_EVENT.pos (  float )
   cvar ALLEGRO_JOYSTICK_EVENT.button
constant /ALLEGRO_JOYSTICK_EVENT

/ALLEGRO_ANY_EVENT
   cvar ALLEGRO_KEYBOARD_EVENT.display
   cvar ALLEGRO_KEYBOARD_EVENT.keycode                 /* the physical key pressed*/
   cvar ALLEGRO_KEYBOARD_EVENT.unichar                 /* unicode character or negative*/
   cvar ALLEGRO_KEYBOARD_EVENT.modifiers               /* bitcfield*/
   cvar ALLEGRO_KEYBOARD_EVENT.repeat                  /* auto-repeated or not*/
constant /ALLEGRO_KEYBOARD_EVENT


/ALLEGRO_ANY_EVENT
   cvar ALLEGRO_MOUSE_EVENT.display
   \ /* ( display) Window the event originate from
   \ * ( x, y) Primary mouse position
   \ * ( z) Mouse wheel position ( 1D 'wheel'), or,
   \ * ( w, z) Mouse wheel position ( 2D 'ball')
   \ * ( pressure) The pressure applied, for stylus ( 0 or 1 for normal mouse)
   \ */
   cvar ALLEGRO_MOUSE_EVENT.x
   cvar ALLEGRO_MOUSE_EVENT.y
   cvar ALLEGRO_MOUSE_EVENT.z
   cvar ALLEGRO_MOUSE_EVENT.w
   cvar ALLEGRO_MOUSE_EVENT.dx
   cvar ALLEGRO_MOUSE_EVENT.dy
   cvar ALLEGRO_MOUSE_EVENT.dz
   cvar ALLEGRO_MOUSE_EVENT.dw
   cvar ALLEGRO_MOUSE_EVENT.button
   cvar ALLEGRO_MOUSE_EVENT.pressure (  float )
constant /ALLEGRO_MOUSE_EVENT



/ALLEGRO_ANY_EVENT
   2 cells cfield ALLEGRO_TIMER_EVENT.count
   2 cells cfield ALLEGRO_TIMER_EVENT.error  \ double-float
constant /ALLEGRO_TIMER_EVENT



\ /* Type: ALLEGRO_USER_EVENT
\ */
\ typedef struct ALLEGRO_USER_EVENT ALLEGRO_USER_EVENT
\
\ struct ALLEGRO_USER_EVENT
\ {
\    _AL_EVENT_HEADER( struct ALLEGRO_EVENT_SOURCE)
\    struct ALLEGRO_USER_EVENT_DESCRIPTOR*__internal__descr
\    intptr_t data1
\    intptr_t data2
\    intptr_t data3
\    intptr_t data4
\ }



/* Event sources */

\ for user events:
function: al_init_user_event_source ( ALLEGRO_EVENT_SOURCE* -- )
\ function: al_destroy_user_event_source ( ALLEGRO_EVENT_SOURCE* -- )
\ /* The second argument is ALLEGRO_EVENT instead of ALLEGRO_USER_EVENT
\ * to prevent users passing a pointer to a too-short structure.
\ */
function: al_emit_user_event ( ALLEGRO_EVENT_SOURCE* ALLEGRO_EVENT* dtor -- )
\ function: al_unref_user_event ( ALLEGRO_USER_EVENT* -- )
\ function: al_set_event_source_data ( ALLEGRO_EVENT_SOURCE* intptr_t data -- )
\ AL_FUNC( intptr_t al_get_event_source_data ( const ALLEGRO_EVENT_SOURCE* -- )



/* Event queues */

function: al_create_event_queue ( -- ALLEGRO_EVENT_QUEUE* )
function: al_destroy_event_queue ( ALLEGRO_EVENT_QUEUE* -- )
function: al_register_event_source ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT_SOURCE* -- )
function: al_unregister_event_source ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT_SOURCE* -- )
function: al_is_event_queue_empty ( ALLEGRO_EVENT_QUEUE* -- bool )
function: al_get_next_event ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT*ret_event -- bool )
function: al_peek_next_event ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT*ret_event -- bool )
function: al_drop_next_event ( ALLEGRO_EVENT_QUEUE* -- bool )
function: al_flush_event_queue ( ALLEGRO_EVENT_QUEUE* -- )
function: al_wait_for_event ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT*ret_event -- )
\ function: al_wait_for_event_timed ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT*ret_event float-secs -- bool )
\ function: al_wait_for_event_until ( ALLEGRO_EVENT_QUEUE*queue ALLEGRO_EVENT*ret_event ALLEGRO_TIMEOUT*timeout -- )


function: al_acknowledge_resize ( display -- )
function: al_reset_new_display_options ( -- )

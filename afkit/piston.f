\ Universal main loop, simple version; no fixed point
\  It just processes events and spits out frames, no timer, no frameskipping.
\  The previous version tried to have frameskipping and framepacing, but it became choppy after
\    an hour or two running and I couldn't figure out the cause.
\  The loop has some common controls:
\    ALT-F12 - break the loop
\    ALT-F4 - quit the process

\ Values
0 value now  \ in frames  ( read-only )
0 value showerr
0 value steperr
0 value pumperr
0 value alt?  \ part of fix for alt-enter bug when game doesn't have focus
0 value ctrl?
0 value shift?
0 value breaking?
0 value 'pump
0 value 'step
0 value 'show
0 value me    \ for Ramen
0 value offsetTable

\ Flags
variable eco   \ enable to save CPU (for repl/editors etc)
variable oscursor   oscursor on  \ turn off to hide the OS's mouse cursor
variable repl   \ <>0 = repl active/visible

\ Defers
defer ?overlay  ' noop is ?overlay  \ render ide  ( - )
defer ?system   ' noop is ?system   \ system events ( - )
defer repl?     :noname  0 ; is repl?

\ Event stuff
create evt  256 /allot
: etype  ( - ALLEGRO_EVENT_TYPE )  evt ALLEGRO_EVENT.TYPE @ ;

: poll  ( - ) pollKB  pollJoys ;
: break ( - ) true to breaking? ;

defer bye
:make bye  al_uninstall_system  0 ExitProcess ; 

define internal
    transform: m1
    variable clipx
    variable clipy
    variable clipw
    variable cliph


using internal
: clip ( x y w h - ) 
    #globalscale * s>f cliph sf!
    #globalscale * s>f clipw sf!
    s>f  clipy sf!
    s>f  clipx sf!
    m1   clipx clipy   al_transform_coordinates
    clipx sf@ f>s
    clipy sf@ f>s
    clipw sf@ f>s
    cliph sf@ f>s al_set_clipping_rectangle
;

: mountw  ( - n ) res x@ #globalscale * ;
: mounth  ( - n ) res y@ #globalscale * ;
: mountwh  mountw mounth ;

: mount  ( - )
    m1 al_identity_transform
    m1 #globalscale s>f 1sf dup al_scale_transform
    fs @ if
        m1
            displayw 2 / mountw 2 / -  s>f 1sf
            repl @ if 0 else 
                displayh 2 / mounth 2 / -  s>f 1sf
            then
                al_translate_transform
    then
    \ m1 0.625e 0.625e 2sf al_translate_transform
    m1 al_use_transform

    0 0 res xy@ clip
    
    ALLEGRO_ADD ALLEGRO_ALPHA ALLEGRO_INVERSE_ALPHA
    ALLEGRO_ADD ALLEGRO_ONE   ALLEGRO_ONE
        al_set_separate_blender
    
;
: unmount ( - ) 
    m1 al_identity_transform
    \ m1 0.625e 0.625e 2sf al_translate_transform
    m1 al_use_transform
    0 0 displaywh clip
    ALLEGRO_ADD ALLEGRO_ALPHA ALLEGRO_INVERSE_ALPHA
    ALLEGRO_ADD ALLEGRO_ONE   ALLEGRO_ONE
        al_set_separate_blender
;

variable (catch)
: try ( code - IOR )
    dup -exit  
    [defined] dev [if]
        sp@ cell+ >r  code> catch (catch) !  r> sp!
        (catch) @
    [else] 
        call 0 
    [then] ;

: suspend ( - ) 
    begin
        eventq evt al_wait_for_event
        etype ALLEGRO_EVENT_DISPLAY_SWITCH_IN = if
            clearkb  false to alt?
            exit 
        then
    again    
;

: standard-events ( - )
    etype ALLEGRO_EVENT_DISPLAY_RESIZE = if  display al_acknowledge_resize  then
    etype ALLEGRO_EVENT_DISPLAY_CLOSE = if  bye  then
    [defined] dev [if]  etype ALLEGRO_EVENT_DISPLAY_SWITCH_OUT = if  suspend  then  [then]
    
    \ still needed in published games, don't remove
    etype ALLEGRO_EVENT_DISPLAY_SWITCH_IN = if
        clearkb  false to alt?
    then

    etype ALLEGRO_EVENT_KEY_DOWN = if
        evt ALLEGRO_KEYBOARD_EVENT.keycode @ case
            <alt>    of  true to alt?  endof
            <altgr>  of  true to alt?  endof
            <lctrl>  of  true to ctrl?  endof
            <rctrl>  of  true to ctrl?  endof
            <lshift>  of  true to shift?  endof
            <rshift>  of  true to shift?  endof
            <f4>     of  alt? -exit  bye  endof
            <f12>    of  alt? -exit  break  endof  
        endcase
    then
    etype ALLEGRO_EVENT_KEY_UP = if
        evt ALLEGRO_KEYBOARD_EVENT.keycode @ case
            <alt>    of  false to alt?  endof
            <altgr>  of  false to alt?  endof
            <lctrl>  of  false to ctrl?  endof
            <rctrl>  of  false to ctrl?  endof
            <lshift>  of  false to shift?  endof
            <rshift>  of  false to shift?  endof
        endcase
    then ;

: al-emit-user-event  ( type - )  \ EVT is expected to be filled, except for the type
    evt ALLEGRO_EVENT.type !  uesrc evt 0 al_emit_user_event ;

: ?hidemouse ( - )
    display oscursor @ if al_show_mouse_cursor else al_hide_mouse_cursor then ; 

: 2s>f ( ix iy - f: x y ) swap s>f s>f ;
: refit ( - )  \ find biggest integer scaling that fits display
    displaywh 2s>f f/ 
        res xy@ 2s>f f/ f> if
        displayh res y@ /
    else
        displayw res x@ /
    then
    to #globalscale
;

: onto  ( bmp - )  dup display = if al_get_backbuffer then al_set_target_bitmap ;
: ?greybg ( - ) fs @ -exit  display onto  unmount  0.1e 0.1e 0.1e 1e 4sf al_clear_to_color ;
: show ( - )
    refit  
    at@ 2>r  
        me >r  offsetTable >r
            ?greybg  mount  display onto
            'show try to showerr
            unmount  display onto  ?overlay
        r> to offsetTable  r> to me  
    2r> at ;
: present ( - ) al_flip_display ;
: ?suppress ( - ) repl? if clearkb then ;
: step ( - )
    me >r  offsetTable >r  at@ 2>r
    ?suppress  'step try to steperr   1 +to now
    2r> at  r> to offsetTable  r> to me ;
: pump ( - ) repl? ?exit  'pump try to pumperr ;

: /go ( - )  resetkb  false to breaking?   >display  false to alt?  false to ctrl?  false to shift? ;
: go/ ( - )  eventq al_flush_event_queue  >host  false to breaking?  ;
: show> ( - <code> ) r> to 'show ;  ( - <code> )  ( - )
: step> ( - <code> ) r> to 'step ;  ( - <code> )  ( - )
: pump> ( - <code> ) r> to 'pump ;  ( - <code> )  ( - )
: get-next-event ( - ) eco @ if al_wait_for_event #1 else al_get_next_event then ;
: @event ( - flag ) eventq evt get-next-event ;
: attend ( - )
    begin  @event  breaking? not and  while
        me >r  offsetTable >r  pump  standard-events  r> to offsetTable  r> to me
        ?system
        eco @ ?exit
    repeat ;
: frame ( - ) show present attend poll step ?hidemouse ;
: go ( - )   /go    begin  frame  breaking? until  go/ ;

\ default demo: dark blue screen with bouncing white square
define internal
    variable x  variable vx  1 vx !
    variable y  variable vy  1 vy !
    :noname
        show>
        0e 0e 0.5e 1e 4sf al_clear_to_color
        x @ y @ over 50 + over 50 + 4s>f 4sf 1e 1e 1e 1e 4sf al_draw_filled_rectangle
        vx @ x +!  vy @ y +!
        vx @ 0< if  x @ 0 < if  vx @ negate vx !  then then
        vy @ 0< if  y @ 0 < if  vy @ negate vy !  then then
        vx @ 0> if  x @ res x@ 50 - >= if  vx @ negate vx !  then then
        vy @ 0> if  y @ res y@ 50 - >= if  vy @ negate vy !  then then
        ;  execute
only forth definitions

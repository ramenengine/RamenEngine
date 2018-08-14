\ Simpler IDE, library-style.
\  This is a semi-one-way street.
\  (For now, we're using SwiftForth's PERSONALITY facility to save
\       time.  Later, a complete replacement for all text output words will need to be implemented...)

\ go> words:
\   REPL  ( -- )  processes commandline events.
\ show> words:
\   .CMDLINE  ( -- )  displays the commandline at given pen position and font, including the current idiom and the stack
\   .OUTPUT  ( -- )  displays commandline output
\ misc words:
\   GO  ( -- )  starts the default REPL interface, no game displayed.  calls RASA
\   RASA  ( -- )  establishes the default REPL interface.  is called by GO
\   CMDFONT  ( -- adr )  a VARIABLE containing the current font for the commandline
\   /CMDLINE  ( -- )  initializes the commandline.  is called by GO
\   MARGINS  ( -- rect )  dimensions for the command history.  defaults to the entire screen, minus 3 rows at the bottom
\       you can redefine them by direct manipulation, just make sure to also do it at resize and fullscreen events.
\   interact  ( -- variable )  variable, when set to ON, the commandline is active.
\   OUTPUT  ( -- variable )  variable that stores the bitmap to draw text output onto.
\   /S  reset the Forth stack


variable consolas
consolas value cmdfont
private:  0  xvar x  xvar y  4 cells xfield colour  struct /cursor
public:
create cursor  /cursor /allot
variable scrolling  scrolling on
create cmdbuf #256 /allot
create history  #256 /allot
create ch  0 c, 0 c,
create attributes
  1 , 1 , 1 , 1 ,      \ white
  0 , 0 , 0 ,     1 ,  \ black
  0.3 , 1 , 0.3 , 1 ,  \ green
  1 , 1 , 0.3 ,   1 ,  \ light yellow
  0 , 1 , 1 ,     1 ,  \ cyan
transform baseline
variable output   \ output bitmap

bu:
create margins  0 , 0 , 0 , 0 ,   \ margins for the command history. (rectangle)
ide:

\ --------------------------------------------------------------------------------------------------
\ low-level stuff
: fw  cmdfont @ fontw ;
: fh  cmdfont @ fonth ;
: cols  fw * ;
: rows  fh * ;
\ : #cmdrows  margins @h 1 - fh / pfloor ;
: rm  margins @x2  displayw min ;
: bm  margins @y2  displayh min ;
: lm  margins @x  displayw >= if  0  else  margins @x  then ;
: tm  margins @y  displayh >= if  0  else  margins @y  then ;
: ?call  ?dup -exit call ;
: ?.catch  ?dup -exit .catch  postpone [ ;
: recall  history count cmdbuf place ;
: store   cmdbuf count history place ;
: typechar  cmdbuf count + c!  #1 cmdbuf c+! ;
: rub       cmdbuf c@  #1 -  0 max  cmdbuf c! ;
: paste     @clipb  #1 -  cmdbuf append ;
: copy      cmdbuf count !clipb ;
: ?paused  pause @ if  -timer  0 +to lag   else  +timer  then ;
: keycode  evt ALLEGRO_KEYBOARD_EVENT.keycode @ ;
: unichar  evt ALLEGRO_KEYBOARD_EVENT.unichar @ ;
private:
  : ctrl?  evt ALLEGRO_KEYBOARD_EVENT.modifiers @ ALLEGRO_KEYMOD_CTRL and ;
  : alt?  evt ALLEGRO_KEYBOARD_EVENT.modifiers @ ALLEGRO_KEYMOD_ALT and ;
public:
: /margins 0 0 displayw displayh 3 rows - margins !xywh ;
: 4@af  4@ 4af ;
: /output  nativew nativeh 2i al_create_bitmap  output ! ;

\ --------------------------------------------------------------------------------------------------
\ Output words
private:
    : get-xy  ( -- #col #row )  cursor x 2@  lm tm 2-  fw fh 2/ 2i ;
    : at-xy   ( #col #row -- )  2s>p fw fh 2*  lm tm 2+  cursor x 2! ;
    : fill  ( w h bitmap -- )  onto  write-rgba blend>  rectf ;
    : clear  ( w h bitmap -- )  0 0 0 0 color  fill ;
    : outputw  rm lm - ;
    : outputh  bm tm - ;
    : get-size  ( -- cols rows )  outputw outputh fw fh 2/ 2i ;
    : scroll
        write-rgba blend>  output @ onto  0 -1 rows at  untinted  output @ blit
        \ lm bm 1 rows - at   outputw 1 rows output @ clear
        -1 rows cursor y +!
    ;
    : cr
        lm cursor x !
        1 rows cursor y +!
        scrolling @ -exit
        cursor y @ bm >= if  scroll  then
    ;
    : (emit)
        ch c!
        cursor x 2@ at  ch #1 print
        fw cursor x +!
        cursor x @ rm >= if  cr  then
    ;
    decimal
        : emit  output @ onto  write-rgba blend>  cmdfont @ font>  cursor colour 4@ color  (emit) ;
        : type  output @ onto  write-rgba blend>  cmdfont @ font>  cursor colour 4@ color  bounds  do  i c@ (emit)  loop ;
        : ?type  ?dup if type else 2drop then ;
    fixed
    : attribute  s>p 4 cells * attributes +  cursor colour  4 imove ;

    : wipe  output @ onto  0 0 0 0 4af al_clear_to_color  0 0 at-xy ;

    : zero  0 ;

    create console-personality
      4 cells , #19 , 0 , 0 ,
      ' noop , \ INVOKE    ( -- )
      ' noop , \ REVOKE    ( -- )
      ' noop , \ /INPUT    ( -- )
      ' emit , \ EMIT      ( char -- )
      ' type , \ TYPE      ( addr len -- )
      ' ?type , \ ?TYPE     ( addr len -- )
      ' cr , \ CR        ( -- )
      ' wipe , \ PAGE      ( -- )
      ' attribute , \ ATTRIBUTE ( n -- )
      ' zero , \ KEY       ( -- char )  \ not yet supported
      ' zero , \ KEY?      ( -- flag )  \ not yet supported
      ' zero , \ EKEY      ( -- echar ) \ not yet supported
      ' zero , \ EKEY?     ( -- flag )  \ not yet supported
      ' zero , \ AKEY      ( -- char )  \ not yet supported
      ' 2drop , \ PUSHTEXT  ( addr len -- )  \ not yet supported
      ' at-xy ,  \ AT-XY     ( x y -- )
      ' get-xy , \ GET-XY    ( -- x y )
      ' get-size , \ GET-SIZE  ( -- x y )
      ' drop , \ ACCEPT    ( addr u1 -- u2)  \ not yet supported
public:

\ --------------------------------------------------------------------------------------------------
\ Command management

: cancel   cmdbuf off ;
: echo     cursor colour 4@  #4 attribute  cr  cmdbuf count type space  cursor colour 4! ;
: interp   echo  cmdbuf count evaluate ;
: obey     store  ['] interp catch ?.catch  cancel  >display ;

\ --------------------------------------------------------------------------------------------------
\ Input handling
: special  ( n -- )
  case
    [char] v of  paste  endof
    [char] c of  copy   endof
    [char] p of  pause toggle  endof
  endcase ;

: idekeys
    \ always processed:
    etype ALLEGRO_EVENT_DISPLAY_RESIZE =
    etype EVENT_FULLSCREEN = or if
        /margins  \ /output
    then
    etype ALLEGRO_EVENT_KEY_DOWN = if
        keycode dup #37 < if  drop exit  then
            case
                <tab> of  interact toggle  endof
            endcase
    then

    \ only when INTERACT is on:
    interact @ -exit
    etype ALLEGRO_EVENT_KEY_CHAR = if
        ctrl? if
            unichar special
        else
            unichar #32 >= unichar #126 <= and if
                unichar typechar  exit
            then
        then
        keycode case
            <up> of  recall  endof
            <down> of  cancel  endof
            <enter> of  alt? ?exit  obey  endof
            <backspace> of  rub  endof
        endcase
    then
;

\ --------------------------------------------------------------------------------------------------
\ Rendering
: .S2 ( ? -- ? )
  #3 attribute
  DEPTH 0> IF DEPTH s>p  0 ?DO S0 @ I 1 + CELLS - @ . LOOP THEN
  DEPTH 0< ABORT" Underflow"
  FDEPTH ?DUP IF
    ."  F: "
    0  DO  I' I - #1 - FPICK N.  #1 +LOOP
  THEN ;
: +blinker interact @ -exit  #frames 16 and -exit  s[ [char] _ c+s ]s ;
: .idiom   'idiom @ ?dup if  #4 attribute  body> >name count #1 - type  then  [char] > emit ;
: .cmdbuf  #0 attribute  cmdfont @ font>  white  cmdbuf count +blinker print ;
: bar      outputw  displayh bm -  black  output @ fill ;
: .output  untinted  output @ blit ;


\ --------------------------------------------------------------------------------------------------
\ redefined STEP> ... makes keyboard state be automatically cleared every frame when interact is on.
0 value 'idestep
: ?clearkb  interact @ if clearkb then ;
: step>  ( -- <code> )  r> to 'idestep  step>  ?clearkb 'idestep call ;

\ --------------------------------------------------------------------------------------------------
global
    : wipe  page ;
    : /s  S0 @ SP! ;
ide:
\ --------------------------------------------------------------------------------------------------
\ "API"

function: al_load_ttf_font  ( zfilename size flags -- font )
#1 constant ALLEGRO_TTF_NO_KERNING
#2 constant ALLEGRO_TTF_MONOCHROME

: bottom  lm bm ;
: .output   untinted  output @ blit ;
: .cmdline
    output @ >r  display al_get_backbuffer output !
    get-xy 2>r  at@ cursor x 2!  bar  scrolling off  .s2  cr  .idiom  .cmdbuf  scrolling on   2r> at-xy
    r> output !
;
: /cmdline
    /s
    \ z" afkit/dev/data/consolas16.png" al_load_bitmap_font  consolas !
    soft
    z" afkit/dev/data/consolab.ttf" #20 ALLEGRO_TTF_NO_KERNING al_load_ttf_font  consolas !
    /output
    1 1 1 1 cursor colour 4!
    /margins
    ['] >display is >ide  \ >IDE is redefined to take us to the display
    interact on
    console-personality open-personality
;
: ?repl  idekeys ;
: rasa-system  idekeys ;
: shade  0 0 0 0.3 color  0 0 at  displaywh rectf  white ;
: rasa-overlay  interact @ if  shade  0 0 at  .output  bottom at  .cmdline  then ;
: rasa  ['] rasa-system  is  ?system  ['] rasa-overlay  is ?overlay ;
: go  /cmdline  rasa  " ld autoexec" ['] evaluate catch ?.catch  begin ok again ;

gild

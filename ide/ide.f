\ SwiftForth only

\ Simpler IDE, library-style.
\  This is a semi-one-way street.
\  (For now, we're using SwiftForth's PERSONALITY facility to save
\       time.  Later, a complete replacement for all text output words will need to be implemented...)

\ go> words:
\   REPL  ( -- )  processes commandline events.
\ show> words:
\   .CMDLINE  ( -- )  displays the commandline at given pen position and font, including the stack
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

ide-loaded on

require afkit/plat/win/clipb.f

variable interact   \ <>0 = repl active/visible

define ideing

include ramen/lib/draw.f
include ramen/lib/v2d.f

s" ramen/ide/data/consolab.ttf" 26 ALLEGRO_TTF_NO_KERNING font: consolas
create cursor 6 cells /allot
: colour 2 cells + ;
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
variable output   \ output bitmap
0 value tempbmp
:is repl?  interact @ ;
create margins 4 cells /allot
0 value outbmp

\ --------------------------------------------------------------------------------------------------
\ low-level stuff
consolas chrw constant fw
consolas chrh constant fh
: cols  fw * ;
: rows  fh * ;
: rm  margins x2@  displayw min ;
: bm  margins y2@  displayh 3 rows -  min ;
: lm  margins x@  displayw >= if  0  else  margins x@  then ;
: tm  margins y@  displayh >= if  0  else  margins y@  then ;
: ?call  ?dup -exit call ;
: recall  history count cmdbuf place ;
: store   cmdbuf count dup if  history place  else  2drop  then ;
: typechar  cmdbuf count + c!  #1 cmdbuf c+! ;
: rub       cmdbuf c@  #1 -  0 max  cmdbuf c! ;
: paste     clipb@  cmdbuf append ;
: copy      cmdbuf count clipb! ;
: keycode  evt ALLEGRO_KEYBOARD_EVENT.keycode @ ;
: unichar  evt ALLEGRO_KEYBOARD_EVENT.unichar @ ;
: /margins  0 0 displaywh 3 rows - margins xywh! ;
: /output  native 2@ al_create_bitmap dup to outbmp output !  outbmp al_clone_bitmap to tempbmp ;

\ --------------------------------------------------------------------------------------------------
\ Output words
: ramen-get-xy  ( -- #col #row )  cursor xy@  lm tm 2-  fw fh 2/ 2i ;
: ramen-at-xy   ( #col #row -- )  2p fw fh 2*  lm tm 2+  cursor xy! ;
: fill  ( w h -- )  write-src blend>  rectf ;
: clear  ( w h bitmap -- )  black 0 alpha  onto>  fill ;
: outputw  rm lm - ;
: outputh  bm tm - ;
: ramen-get-size  ( -- cols rows )  outputw outputh fw fh 2/ 2i ;
: scroll
    write-src blend>
    tempbmp onto>  0 0 at  untinted  output @ blit
    output @ onto>  0 -1 rows at  untinted  tempbmp blit
    -1 rows cursor y+!
;
: ramen-cr
    lm cursor x!
    1 rows cursor y+!
    scrolling @ -exit
    cursor y@ 1 rows + bm >= if  scroll  then
;
: (emit)
    ch c!
    cursor xy@ at  ch #1 print
    fw cursor x+!
    cursor x@ 1 cols + rm >= if  ramen-cr  then
;
decimal
    : ?b  output @ display <> if write-src else interp-src then ;
    : ramen-emit   output @ onto>  ?b blend>  consolas fnt !  cursor colour 4@ rgba  (emit) ;
    : ramen-type   output @ onto>  ?b blend>  consolas fnt !  cursor colour 4@ rgba  bounds  do  i c@ (emit)  loop ;
    : ramen-?type  dup if type else 2drop then ;
fixed
: ramen-attribute  1p 4 cells * attributes +  cursor colour  4 imove ;

: wipe  0 0 0 0 output @ clearbmp  0 0 ramen-at-xy ;

: zero  0 ;

create ide-personality
  4 cells , #19 , 0 , 0 ,
  ' noop , \ INVOKE    ( -- )
  ' noop , \ REVOKE    ( -- )
  ' noop , \ /INPUT    ( -- )
  ' ramen-emit , \ EMIT      ( char -- )
  ' ramen-type , \ TYPE      ( addr len -- )
  ' ramen-?type , \ ?TYPE     ( addr len -- )
  ' ramen-cr , \ CR        ( -- )
  ' wipe , \ PAGE      ( -- )
  ' ramen-attribute , \ ATTRIBUTE ( n -- )
  ' zero , \ KEY       ( -- char )  \ not yet supported
  ' zero , \ KEY?      ( -- flag )  \ not yet supported
  ' zero , \ EKEY      ( -- echar ) \ not yet supported
  ' zero , \ EKEY?     ( -- flag )  \ not yet supported
  ' zero , \ AKEY      ( -- char )  \ not yet supported
  ' 2drop , \ PUSHTEXT  ( addr len -- )  \ not yet supported
  ' ramen-at-xy ,  \ AT-XY     ( x y -- )
  ' ramen-get-xy , \ GET-XY    ( -- x y )
  ' ramen-get-size , \ GET-SIZE  ( -- x y )
  ' drop , \ ACCEPT    ( addr u1 -- u2)  \ not yet supported

\ --------------------------------------------------------------------------------------------------
\ Command management

: cancel   0 cmdbuf ! ;
: echo     cursor colour 4@  #4 attribute  cr  cmdbuf count type space  cursor colour 4! ;
: interp   cmdbuf count (evaluate) ;
\ : ?errormsg  errormsg ; 
\ ' ?errormsg is .catch
: ?.catch  ?dup if  .catch  then ;
: obey     store  echo  ['] interp catch ?.catch  0 cmdbuf ! ;

\ --------------------------------------------------------------------------------------------------
\ Input handling

: toggle  dup @ not swap ! ;

: special  ( n -- )
  case
    [char] v of  paste  endof
    [char] c of  copy   endof
  endcase ;

: idekeys
    \ always:
    etype ALLEGRO_EVENT_DISPLAY_RESIZE =
        etype FULLSCREEN_EVENT =  or if  /margins  then

    etype ALLEGRO_EVENT_KEY_DOWN = if
        keycode dup #37 < if  drop exit  then
            case
                <tab> of  interact toggle  endof
            endcase
    then

    \ only when REPL? is true:
    repl? -exit
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

\ ----------5----------------------------------------------------------------------------------------
\ Rendering
: .S2 ( ? -- ? )
  #3 attribute
  DEPTH 0> IF DEPTH 1p  0 ?DO S0 @ I 1 + CELLS - @ . LOOP THEN
  DEPTH 0< ABORT" Underflow"
  FDEPTH ?DUP IF
    ."  F: "
    0  DO  I' I - #1 - FPICK N.  #1 +LOOP
  THEN ;
  
: ?.errs
    showerr  if  ." SHOWERR "  then
    steperr  if  ." STEPERR "  then ;

: +blinker repl? -exit  frmctr 16 and -exit  s[ [char] _ c+s ]s ;
: .cmdbuf  #0 attribute  consolas fnt !  white  cmdbuf count +blinker type ;
: bar      outputw  displayh bm -  dblue  fill ;
: ?trans   repl? if 1 alpha else 0.66 alpha then ;
: ?shad    repl? if 0.9 alpha else 0.4 alpha then ;
: .output  2 2 +at  black ?shad  outbmp blit  -2 -2 +at  white ?trans  outbmp blit ;
: bottom   lm bm ;
: .cmdline
    bar  
    output @ >r  display output !
        get-xy 2>r
            at@ cursor xy!  scrolling off
            ?.errs  .s2  cr
            .cmdbuf
            scrolling on
        2r> at-xy
    r> output !
    output @ onto> noop  \ fixes the lag bug...  why though?
;



\ --------------------------------------------------------------------------------------------------
\ bring it all together

: /ide  >ide  /output  1 1 1 1 cursor colour 4!  /margins ;  \ don't remove the >IDE; fixes a bug
: /repl
    /s   \ clear the stack
    interact on
    ['] >display is >ide               \ >IDE is redefined to take us to the display
    >ide
    ide-personality open-personality
;
: shade  black 0.33 alpha  0 0 at  displaywh rectf  white ;

: ide-system  idekeys ;
: ide-overlay  repl? if shade then  0 0 at  .output  bottom at  repl? if .cmdline then ;
: rasa  ['] ide-system  is  ?system  ['] ide-overlay  is ?overlay ;
: autoexec s" ld autoexec" ['] evaluate catch ?.catch ; 


only forth definitions also ideing
: ide  /ide  /repl  rasa  ( autoexec )  begin go again ;
: wipe  page ;
: /s  S0 @ SP! ;
only forth definitions
marker (empty)
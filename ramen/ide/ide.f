\ SwiftForth only

s" ramen/ide/data/consolab.ttf" 26 ALLEGRO_TTF_NO_KERNING font: consolas
create margins 4 cells /allot
: ?.catch  ?dup if  postpone [  .catch  then ;

define ideing
include afkit/plat/win/clipb.f
include ramen/ide/v2d.f

0 value outbuf
0 value >outbuf

create cursor 6 cells /allot   \ col, row, color (r,g,b,a)
: colour 2 cells + ;
variable scrolling  scrolling on
create replbuf #1024 /allot
create cmdbuf #1024 /allot
create history #1024 /allot
create ch  0 c, 0 c,
create attributes
  1 , 1 , 1 , 1 ,      \ 0 white
  0 , 0 , 0 ,     1 ,  \ 1 black
  0.3 , 1 , 0.3 , 1 ,  \ 2 green
  1 , 1 , 0.3 ,   1 ,  \ 3 light yellow
  0 , 1 , 1 ,     1 ,  \ 4 cyan
  1.0 , 0 , 0.5 ,     1 ,  \ 5 purple
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
  1 , 1 , 1 , 1 ,      \ 0 white
\ 0 value tempbmp
:make repl?  repl @ ;
0 value outbmp

( command buffer )
: recall  history count cmdbuf place ;
: store   cmdbuf count dup if  history place  else  2drop  then ;
: typechar  cmdbuf count + count!  #1 cmdbuf count+! ;
: rub       cmdbuf count nip  #1 -  0 max  cmdbuf count! ;
: paste     clipb@  cmdbuf append ;
: copy      cmdbuf count clipb! ;

( init )
: /output
    64 megs allocate throw to outbuf
    outbuf to >outbuf
    #2048 #2048 al_create_bitmap to outbmp  
; \    outbmp al_clone_bitmap to tempbmp ;

( metrics )
consolas char A chrw constant fw
consolas chrh constant fh
\ : right-margin  ( - n ) margins x2@ fw /  displayw fw /  min ;
\ : bottom-margin  ( - n ) margins y2@ fh /  displayh 3 rows - fh /  min ;
: #cols  ( - n ) displayw fw / pfloor 128 min ;
: #rows    ( - n ) displayh fh / 3 - pfloor ;

( cursor )
: ramen:get-xy  ( - #col #row )  cursor xy@ 2i ;
: ramen:at-xy   ( #col #row - )  2p cursor xy! ;
: ramen:get-size  ( - cols rows )  #cols #rows   2i ;

( utils )
: fillrect  ( w h - )  write-src blend>  rectf ;
: clear  ( w h bitmap - )  black 0 alpha  onto>  fillrect ;

( output )
: bufloc  >outbuf cursor y@ #128 * + cursor x@ 1i + ;
: scroll
    #128 +to >outbuf
    bufloc #128 erase
;
: ramen:cr
    0 cursor x!
    1 cursor y+!
    scrolling @ -exit
    cursor y@ #rows   >= if  scroll  -1 cursor y+! then
;
: (emit)
    bufloc c!
    1 cursor x+!
    cursor x@ #cols >= if  ramen:cr  then
;
decimal
    \ : ?b  output @ display <> if write-src else interp-src then ;
    \ : at>  r>  at@ 2>r  call  2r> at ;
    : ramen:emit
      ( at>  output @ onto>  ?b blend>  consolas fnt !  cursor colour 4@ rgba )
      (emit) ;
    : ramen:type
      ( at>  output @ onto>  ?b blend>  consolas fnt !  cursor colour 4@ rgba )
      bounds  do  i c@ (emit)  loop ;
    : ramen:?type  dup if type else 2drop then ;
fixed
: ramen:attribute  1p 4 cells * attributes +  cursor colour  4 imove ;

: ramen:page
  >outbuf cursor y@ 1 + #128 * + to >outbuf
  0 0 cursor xy!
  >outbuf #128 #rows * erase ;

: zero  0 ;
create ide-personality
  4 cells , #19 , 0 , 0 ,
  ' noop , \ INVOKE    ( - )
  ' noop , \ REVOKE    ( - )
  ' noop , \ /INPUT    ( - )
  ' ramen:emit , \ EMIT      ( char - )
  ' ramen:type , \ TYPE      ( addr len - )
  ' ramen:?type , \ ?TYPE     ( addr len - )
  ' ramen:cr , \ CR        ( - )
  ' ramen:page , \ PAGE      ( - )
  ' ramen:attribute , \ ATTRIBUTE ( n - )
  ' zero , \ KEY       ( - char )  \ not yet supported
  ' zero , \ KEY?      ( - flag )  \ not yet supported
  ' zero , \ EKEY      ( - echar ) \ not yet supported
  ' zero , \ EKEY?     ( - flag )  \ not yet supported
  ' zero , \ AKEY      ( - char )  \ not yet supported
  ' 2drop , \ PUSHTEXT  ( addr len - )  \ not yet supported
  ' ramen:at-xy ,  \ AT-XY     ( x y - )
  ' ramen:get-xy , \ GET-XY    ( - x y )
  ' ramen:get-size , \ GET-SIZE  ( - x y )
  ' drop , \ ACCEPT    ( addr u1 - u2)  \ not yet supported

( command buffer stuff )
: cancel   0 cmdbuf ! ;
: echo     cursor colour 4@  #4 attribute  cr  cmdbuf count type space  cursor colour 4! ;
: interp   cmdbuf count (evaluate) ;
\ : ?errormsg  errormsg ; 
\ ' ?errormsg is .catch
: obey     store  echo  ['] interp catch ?.catch  0 cmdbuf ! ;

( hotkey stuff )
: toggle  dup @ not swap ! ;

: (rld)    cr ." Reloading... " s" rld" evaluate ;

: special  ( n - )
    case
        [char] v of  paste  endof
        [char] c of  copy   endof
    endcase ;

: pageup  #rows -4 / pfloor #128 * +to >outbuf  >outbuf outbuf max to >outbuf ;
: pagedown  #rows 4 / pfloor #128 * +to >outbuf ;

: idekeys
    ( always )
    
\    etype ALLEGRO_EVENT_DISPLAY_RESIZE =
\        etype FULLSCREEN_EVENT =  or if  /margins  then

    etype ALLEGRO_EVENT_KEY_DOWN = if
        keycode #37 < ?exit
        keycode case
            <tab> of  repl toggle  endof
            <f5> of
                shift? if
                    s" session.f" file-exists if
                        s" session.f" included
                    then
                else
                    [defined] rld [if] ['] (rld) catch ?.catch [then]
                then
            endof  
            
        endcase
    then


    ( only when REPL? is true )
    repl? -exit
    etype ALLEGRO_EVENT_KEY_CHAR = if
        ctrl? if
            unichar special
        else
            alt? ?exit
            unichar #32 >= unichar #126 <= and if
                unichar typechar  exit
            then
        then
        keycode case
            <up> of  recall  endof
            <down> of  cancel  endof
            <enter> of  alt? ?exit  obey  endof
            <backspace> of  rub  endof
            <pgup> of  pageup  endof
            <pgdn> of  pagedown  endof
        endcase
    then
;

( rendering )
: draw-outbuf
  >outbuf  
  consolas font>
  at@ 2>r
  #rows   for
    dup #cols 1i #128 min print
    0 fh +at
    #128 +
  loop
  drop
  2r> at
;

: ?...  dup 16 > if dup 16 - else 0 then ;
: .S2 ( ? - ? )
    depth -exit
    #3 attribute
    ." ( " depth i. ." ) " 
    DEPTH 0> IF DEPTH 1p ?... ?DO S0 @ I 1 + CELLS - @
      base @ #16 = if h. else . then  LOOP THEN
    DEPTH 0< ABORT" Underflow"
    FDEPTH ?DUP IF
      ."  F: "
      0  DO  I' I - #1 - FPICK N.  #1 +LOOP
    THEN ;

: ?.errs
    showerr  if  ." SHOWERR "  then
    steperr  if  ." STEPERR "  then ;

: +blinker repl? -exit  now 16 and -exit  s[ [char] _ +c ]s ;
: .cmdbuf  #0 attribute  consolas fnt !  white  cmdbuf count +blinker type ;
: bar      displayw  displayh #rows   fh * -  dblue  fillrect ;
: ?trans   repl? if 1 alpha else 0.8 alpha then ;
: ?shad    repl? if 1 alpha else 0.25 alpha then ;

: (preren)
  outbmp onto> black 0 alpha backdrop white draw-outbuf
;
: .output
  0 0 at
  (preren)
   2 2 +at  black ?shad   outbmp tblit
   -4 -4 +at  black ?shad outbmp tblit
   4 0 +at  black ?shad   outbmp tblit
   -4 4 +at  black ?shad  outbmp tblit
   2 -2 +at  white ?trans outbmp tblit
;    
: bottom   0 #rows   fh * ;
: .cmdline
    repl @ if bar then
      get-xy 2>r  >outbuf >r
          replbuf to >outbuf
          replbuf #1024 erase
          0 0 cursor xy!  scrolling off
          ?.errs  repl @ if
            .s2 
            .cmdbuf
          then
          scrolling on
          white draw-outbuf
      r> to >outbuf  2r> at-xy
\    output @ onto> noop  \ fixes the lag bug...  why though?
;

\ --------------------------------------------------------------------------------------------------
\ bring it all together

: /ide  >host  /output  1 1 1 1 cursor colour 4!  ( /margins ) ;  \ don't remove the >host; fixes a bug
: /repl
    /s   \ clear the stack
    repl on
\    ['] >display is >host               \ >host is redefined to take us to the display
 \   >host
    >display
    ide-personality open-personality
;
: shade  dgrey 0.5 alpha  0 0 at  displaywh rectf  white ;
: ?rest
    source-id close-file drop
    [in-platform] sf [if]  begin refill while interpret repeat  [then] ; 

only forth definitions also ideing
: ide:pageup    pageup ;
: ide:pagedown  pagedown ;

: ide-system  idekeys ;
: ide-overlay  0 0 at  unmount  repl @ if shade then  .output  bottom at .cmdline ;
: rasa  ['] ide-system  is ?system  ['] ide-overlay  is ?overlay ;
: -ide  close-personality  HWND btf ;
: ide  rasa  /repl  ['] ?rest catch ?.catch  go  -ide ;
: /s  S0 @ SP! ;
: quit  -ide cr quit ;
: wipe  0 0 cursor xy!  outbuf to >outbuf  outbuf #128 #rows * erase ;

/ide  
only forth definitions
marker (empty) 
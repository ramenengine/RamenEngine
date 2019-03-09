\ None of this needs to be ported to other systems.  All non-essential.

: l locate ;
: e edit ;
variable newquit


create backup 11 cells allot

: savestack
    dup
    depth 10 min cells backup !
    sp@  backup cell+  backup @ move
    drop ;

: restorestack
    s0 @ backup @ - dup sp!
        backup cell+ swap backup @ move
    drop ;

: (QUIT) ( - )
    .STACK  BEGIN
    REFILL DROP  INTERPRET  savestack  PROMPT  AGAIN ;

: asdfQUIT ( - )
   BEGIN
      R0 @ RP!         \ clear return stack
      /INTERPRETER
      newquit @ not if  newquit on  else  prompt  then
      ['] (QUIT) CATCH .catch
      restorestack
      \ S0 @ SP!  \ resets datastack
      \ /NDP  \ resets fstack
   AGAIN ;

\ THIS DOESN'T WORK YET ^^^^^^


: newprompt
    cr
    DEPTH 0> if  DEPTH 0 DO  S0 @ I 1+ CELLS - @ h.  LOOP  ." > " THEN
    depth 0= if ." > " then
    \ newquit @ not if  quit  then
    ;

    \ FDEPTH ?DUP IF
    \   ."  FSTACK: "
    \   0  DO  I' I - 1- FPICK N.  LOOP
    \ THEN ;

\ ' newprompt is prompt

: /s  s0 @ sp! ;
: empty  /s empty ;

: .s  base @ >r hex .s r> base ! ;


create ldr 256 /allot
: rld  ldr count nip -exit ldr count included ;
: ld   bl parse ldr place  s" .f" ldr append  rld ;


\ don't move this
: (EVALUATE)
   SAVE-INPUT N>R
   ( c-addr u ) #TIB 2!  >IN OFF  LINE OFF  BLK OFF  -1 'SOURCE-ID !
   ['] INTERPRET CATCH ( * )
   ( * ) DUP IF  POSTPONE [   THEN
   NR> RESTORE-INPUT DROP ( * ) THROW ;

warning off

\ Multitasking for game objects

\ The following words should only be used within a task:
\  PAUSE END FRAMES SECS
\ The following words should never be used within a task:
\  - External calls
\  - Console output 
\  (See below for a workaround mechanism)

redef on
    var sp  var rp  30 cells field ds  60 cells field rs
redef off

create main  /object /allot  \ proxy for the Forth data and return stacks

\ RAMEN version:
\  Uses NXTEN to go to next object.
\  We don't use objlists' counts and instead check ME for 0 to know when to break.
\  Therefore you cannot call MULTI on a pool, only a plain objlist.

\ variable tasks  \ todo: use this instead of checking me

\ important internal note: this word must not CALL anything or use the return stack. (why?)
: nxten  begin  nxt  me -exit  en @ until ;

variable (lnk)
: pause
    \ save state
    dup \ ensure TOS is on stack
    sp@ sp !
    rp@ rp !
    \ look for next task.  rp=0 means no task.  end of list = jump to main task and resume that
    begin  nxten  me if  rp @  else  main as  true  then  until
    lnk @ (lnk) !
    \ restore state
    rp @ rp!
    sp @ sp!
    drop \ ensure TOS is in TOS register
;
: pauses  for  pause  loop ;
: secs   fps * pauses ;  \ not meant for precision timing

\ external-calls facility - say "<val> ['] word later" to schedule a word that calls an external library.
\ you can pass a single parameter to each call, such as an object or an asset.
\ NOTE: you don't have to consume the parameter, and as a bonus, you can leave as much as you want
\ on the stack.

create queue 1000 stack 
: later  ( val xt -- )  swap queue push queue push ;
: arbitrate
    {
        queue sbounds do  sp@  i  swap >r  2@ execute  r> sp!  2 cells +loop
        queue 0 truncate
    } ;

0 value caught
: self?  sp@ ds >=  sp@ rs <= and ;
: (halt)    begin pause again ;

decimal
    : perform> ( n -- <code> )
        self? if    ds 28 cells + sp!  r>  rs 58 cells + rp!  >r  exit
              else  ds 28 cells + !  ds 27 cells + sp !  r> rs 58 cells + !  rs 58 cells + rp !
                    ['] (halt) >code rs 59 cells + !
              then ;

    : perform  ( xt n obj -- )
        >{
        ds 28 cells + !
        ds 27 cells + sp !
        >code rs 58 cells + !
        ['] (halt) >code rs 59 cells + !
        rs 58 cells + rp !
        }
    ;
fixed

: end    0 perform> me remove pause ;
: halt   0 perform> begin pause again ;

\ pulse the multitasker.
: multi  ( objlist -- )
    dup ol.count @ 0= if drop exit then
    {
        ol.first @ main 's lnk !
        dup
        sp@ main 's sp !
        rp@ main 's rp !
        main as  ['] pause catch if
            cr ." A task crashed; stopping. "  empty exit
        then
        drop
    } 
    arbitrate
;

\ cmdline only:
: direct  ( obj -- <word> )  '  0  rot  perform ;
: direct:  ( obj -- ... code ... ; )  :noname  [char] ; parse evaluate  0  rot  perform ;


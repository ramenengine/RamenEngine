
\ Multitasking for game objects

\ The following words should only be used within a task:
\  PAUSE END FRAMES SECS
\ The following words should never be used within a task:
\  - External calls
\  - Console output 
\  (See below for a workaround mechanism)

redef on
    var sp  var rp  20 cells field ds  20 cells field rs
redef off

create main  object  \ proxy for the Forth data and return stacks

\ RAMEN version:
\  Uses NXTEN to go to next object.
\  To avoid using the tiny return stack of the tasks, we don't use objlists' counts, and instead rely on ME being 0 to break.
\  Therefore you cannot call MULTI on a pool, only a plain objlist.

\ important internal note: this word must not CALL anything or use the return stack. (why?)
: nxten  begin  nxt  me -exit  en @ until ;
: pause
    \ save state
    dup \ ensure TOS is on stack
    sp@ sp !
    rp@ rp !
    \ look for next task.  rp=0 means no task.  end of list = jump to main task and resume that
    begin  nxten  me  if  rp @  else  main as  true  then  until
    \ restore state
    rp @ rp!
    sp @ sp!
    drop \ ensure TOS is in TOS register
;
: end    remove pause ;
: halt   begin pause again ;
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

\ pulse the multitasker.
: multi  ( objlist -- )
    {
        ol.first @ main 's lnk !
        dup
        sp@ main 's sp !
        rp@ main 's rp !
        main as  ['] pause catch
        ?dup if
            main as  rp @ rp! sp @ sp!  throw
        then
        drop
    } 
    arbitrate
;

: self?  sp@ ds >=  sp@ rs <= and ;

decimal
    : perform> ( n -- <code> )
        self? if    ds 18 cells + sp!  r>  rs 18 cells + rp!  >r  exit
              else  ds 18 cells + !  ds 17 cells + sp !  r> rs 18 cells + !  rs 18 cells + rp !
                    ['] halt >code rs 19 cells + !
              then ;

    : perform  ( xt n obj -- )
        { as
        ds 18 cells + !
        ds 17 cells + sp !
        >code rs 18 cells + !
        ['] halt >code rs 19 cells + !
        rs 18 cells + rp !
        }
    ;
fixed

: direct  ( obj -- <word> )  '  0  rot  perform ;
: direct:  ( obj -- ... code ... ; )  :noname  [char] ; parse evaluate  0  rot  perform ;

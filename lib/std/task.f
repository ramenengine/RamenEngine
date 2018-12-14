
\ Multitasking for game objects

\ The following words should only be used within a task:
\  PAUSE END FRAMES SECS
\ The following words should never be used within a task:
\  - External calls
\  - Console output 
\  (See below for a workaround mechanism)

redef on
    var sp <adr  30 cells field ds <skip
    var rp <adr  60 cells field rs <skip
redef off

create main object,  \ proxy for the Forth data and return stacks

: nxten  begin  me node.next @ as  me -exit  en @ until ;
: pause
    \ save state
    dup \ ensure TOS is on stack
    sp@ sp !
    rp@ rp !
    \ look for next task.  rp=0 means no task.  end of list = jump to main task and resume that
    begin  nxten  me if  rp @  else  main dup as  then  until
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

create queue 1000 stack,
: later  ( val xt - )  swap queue push queue push ;
: arbitrate
    {
        queue length for  sp@  i 2 * queue []  swap >r  2@ execute  r> sp!  loop
        queue vacate
    } ;

0 value caught
: self?     sp@ ds >=  sp@ rs <= and ;
: (halt)    begin pause again ;

decimal
    : perform> ( n - <code> )
        \ self? if    ds 28 cells + sp!  r>  rs 58 cells + rp!  >r  exit
\              else
        ds 28 cells + !  ds 27 cells + sp !  r> rs 58 cells + !  rs 58 cells + rp !
        ['] (halt) >code rs 59 cells + !
        self? if pause then
\              then 
;
    : perform  ( xt n obj - )
        >{
        ds 28 cells + !
        ds 27 cells + sp !
        >code rs 58 cells + !
        ['] (halt) >code rs 59 cells + !
        rs 58 cells + rp !
        }
    ;
fixed

: end    0 perform> me dismiss pause ;
: halt   0 perform> begin pause again ;

\ pulse the multitasker.
: multi  ( objlist - )
    dup length 0= if drop exit then
    {
        >first main node.next !
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
: direct  ( obj - <word> )  '  0  rot  perform ;
: direct:  ( obj - ... code ... ; )  :noname  [char] ; parse evaluate  0  rot  perform ;


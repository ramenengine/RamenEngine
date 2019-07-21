0 value task  \ current task

fixed

extend: _actor
    var sp <adr  64 cells field ds <skip
    var rp <adr  var (rs) <adr
    var (task)  <flag
;class

8 kbytes dup class: _taskstack  \ grows downwards so we don't have to add any fields
;class


: rs  (rs) @ ;
: dtop  ds 64 cells + ;
: rtop  rs 8 kbytes + ;

: .ds  ds 64 cells idump ;


create main _actor static, \ proxy for the Forth data and return stacks
main to task

: (more)  ( - flag )
    begin  me node.next @ dup -exit   as   en @ until  true ;

: pause  ( - ) 
    dup \ ensure TOS is on stack
    sp@ sp !
    rp@ rp !
    \ look for next task.  end of list = jump to main task and resume that
    begin  (more) if  (task) @  else  main dup as  then  until
    me to task
    \ restore state
    rp @ rp!
    sp @ sp!
    drop \ ensure TOS is in TOS register
;
: pauses  ( n - ) for  pause  loop ;
: seconds  ( n - n ) fps * ;  \ not meant for precision timing
: delay  ( n - ) seconds pauses ;
: running?     sp@ ds >= sp@ dtop < and ;
: halt   (task) off  running? if pause then ;
: end    me dismiss halt ;
: ?end   -exit end ;

decimal
    : ?stacks  (rs) @ ?exit  _taskstack dynamic (rs) ! ;
    : perform  ( n xt - )
        ?stacks  \ tasks don't allocate their return stacks until their first PERFORM
        (task) on
        running? if
            rtop cell- rp!
            ( xt ) >code >r
            ( n )
            dtop cell- cell- sp!
        ;then
        ( xt ) >code rtop cell- cell- !
        ( n ) dtop cell- !
        dtop cell- cell- sp !
        ['] halt >code rtop cell- !
        rtop cell- cell- rp !
    ;
    : perform> ( n - <code> )
        r> code> perform ;

fixed

\ pulse the multitasker.
: multi  ( objlist - )
    dup 0= if drop ;then
    dup length 0= if drop ;then
    >first main node.next !
    dup
    sp@ main 's sp !
    rp@ main 's rp !
    main {
        begin
            ['] pause catch if
                cr ." A task crashed. Halting it."
                dtop cell- sp! .me
                cr ." Data stack: "
                .ds
                (task) off  \ don't call HALT, we don't want PAUSE
            then
        me node.next @ 0= me main = or until
    }
    drop
    main to task
;

: free-task  ( - )
    (rs) @ -exit  (rs) @ destroy ;


: task:free-node
    dup _actor is? not if  destroy ;then
    dup actor:free-node
    { free-task }
;


\ : empty  sp@ main 's sp !  rp@ main 's rp !  empty ;
sp@ main 's sp !  rp@ main 's rp !

' task:free-node is free-node



( event system )
create listeners 100 stack,
create args 100 stack,

: :listen  ( - <code> ; ) ( me=source event c - event c )
    :noname listeners push ; 

: (dispatch)  ( event c xt - event c )
    sp@ >r me { execute } r> sp! drop ;

: +args  ( ... #params - )
    dup >r args pushes r> args push ;

: -args  ( - )
    args length args pop - 1 - args truncate ;

: args@  ( - ... )
    args >top dup @ for cell- dup >r @ r> loop drop ;

: occur ( ... #params event c - )
    2>r +args 2r> ['] (dispatch) listeners each 2drop -args ;

: occurred  ( event c event c - event c ... true | event c false )
    2over 2>r $= if 2r> args@ true ;then 2r> 0 ;
    
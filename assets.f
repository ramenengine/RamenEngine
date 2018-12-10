\ Asset manager, "toolbox" version; includes standard synchronous loader

cell #256 + constant /assetheader
defer initdata ( - )

\ ------------------------------------------------------------------------------
\ Asset framework

create assets 1000 *stack drop

: register ( reloader-xt asset - ) dup assets push  ! ;
: -assets ( - ) assets vacate ;
: srcfile ( - ) cell+ ;

\ The first cell in every asset is a reloader XT.
: reload  ( asset - )  ( asset - )  dup @ execute ;

\ Note: Don't worry that the paths during development are absolute;
\ in publish.f, all asset paths are "normalized".
: findfile ( path c - path c )
    locals| c fn |
    fn c 2dup file-exists ?exit
    including -name #1 + 2swap strjoin 2dup file-exists ?exit
    true abort" File not found" ;

: defasset  ( - <name> )  struct  /assetheader lastbody struct.size ! ;
: .asset  ( asset - ) srcfile count dup if  type  else  2drop  then ;
: .assets  ( - ) assets each> cr .asset ;
: loadtrig  ( xt - )  here swap , assets push ;

\ ------------------------------------------------------------------------------
\ Standard synchronous loader

:is initdata  each> reload ;

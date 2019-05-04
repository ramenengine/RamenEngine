( ---=== Asset framework ===--- )

cell #256 + cell+ constant /assetheader
defer initdata ( - )

create assets 1000 *stack drop
variable permanent   permanent on
variable #permanents

\ "permanent" or "system" assets; not needed by games so reloader is a no-op
: ?permanent  permanent @ -exit   nip ['] drop swap  1 #permanents +! ;

: register ( reloader-xt unloader-xt asset - )
    cr ." [Asset] " #tib 2@ swap type
    ?permanent  dup assets push  2! ;


\ structure:  reloader , unloader , filepath ... 
: reload  ( asset - )  ( asset - )  dup @ execute ;
: unload  ( asset - )  ( asset - )  dup cell+ @ execute ;
: srcfile ( asset - adr ) cell+ cell+ ;


: -assets ( - )  ['] unload assets each   #permanents @ assets truncate ;


\ Note: Don't worry that the paths during development are absolute;
\ in publish.f, all asset paths are "normalized".
: findfile ( path c - path c )
    locals| c fn |
    fn c 2dup file-exists ?exit
    including -name #1 + 2swap strjoin 2dup file-exists ?exit
    true abort" File not found" ;

: asset:  ( - <name> )  struct:  /assetheader lastbody struct.size ! ;
: .asset  ( asset - ) srcfile count dup if  type  else  2drop  then ;
: .assets  ( - ) assets each> cr .asset ;
: asset?  srcfile count nip 0<> ;

( Loadtrigs )
3 cells constant loadtrig-size

: +loadtrig  ( xt - )
    cr ." [Loadtrig] " #tib 2@ swap type
    here assets push   ,  ['] drop ,  0 , ;

( Standard synchronous loader )
:make initdata  assets each> reload ;

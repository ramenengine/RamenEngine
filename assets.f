\ Asset manager, "toolbox" version; includes standard synchronous loader

cell #256 + constant /assetheader
defer initdata ( -- )

\ ------------------------------------------------------------------------------
\ forward-linked lists; only to be used in this file; temporary!!!
\ TODO: factor out the list code from obj.f and put in utils.f

create dmy 0 , 0 ,

:slang flist  ( -- <name> )  \ declare a list
  create    ( first ) dmy , ( last ) dmy , ( count ) 0 , ;

: listlink   ( item list -- )  \ add an item to a list
  swap >r  dup cell+ @  here   0 , r> ,  locals| thislink lastlink list |
  thislink lastlink !  thislink list cell+ !   1 list cell+ cell+ +! ;

:slang listlen  ( list -- count )    cell+ cell+ @ ;

:slang traverse>  ( xt list -- )  ( item -- )
  @  r> locals| code |
  begin @ dup while dup >r  cell+ @ code call  r> repeat  drop ;

:slang -flist  >r  dmy r@ !  dmy r@ cell+ !   0 r> cell+ cell+ ! ;

\ ------------------------------------------------------------------------------
\ Asset framework

flist (assets)
: register  ( reloader-xt asset -- ) dup (assets) listlink  ( xt asset ) ! ;
: -assets  (assets) -flist ;
: assets>  postpone (assets)  postpone traverse> ; immediate
: srcfile  cell+ ;

\ The first cell in every asset is a reloader XT.
: reload  ( asset -- )  ( asset -- )  dup @ execute ;
: #assets  (assets) listlen ;

\ Note: Don't worry that the paths during development are absolute;
\ in publish.f, all asset paths are "normalized".
: findfile
    locals| c fn |
    fn c 2dup file-exists ?exit
    including -name #1 + 2swap strjoin 2dup file-exists ?exit
    true abort" File not found" ;

: defasset  ( -- <name> )  create /assetheader , ;
: .asset  srcfile count dup if  type  else  2drop  then ;
: .assets  assets> cr .asset ;
: loadtrig  ( xt -- )  here   swap ,   (assets) listlink ;

\ ------------------------------------------------------------------------------
\ Standard synchronous loader

:is initdata  assets> reload ;

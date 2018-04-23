\ Asset manager, "toolbox" version; includes standard synchronous loader


\ ------------------------------------------------------------------------------
\ forward-linked lists; only to be used in this file; temporary!!!
\ TODO: factor out the list code from obj.f and put in utils.f

: flist  ( -- <name> )  \ declare a list
  create    ( first ) 0 , ( last ) 0 , ( count ) 0 ,
            here dup  dup 3 cells - 2!
            ( next ) 0 , ( data ) 0 , ;

: listlink   ( item list -- )  \ add an item to a list
  swap >r  dup cell+ @  here   0 , r> ,  locals| thislink lastlink list |
  thislink lastlink !  thislink list cell+ !   1 list cell+ cell+ +! ;

: listlen  ( list -- count )    cell+ cell+ @ ;

: traverse>  ( xt list -- )  ( item -- )
  @  r> locals| code |
  begin @ dup while dup >r  cell+ @ code call  r> repeat  drop ;

\ ------------------------------------------------------------------------------
\ Asset framework

defer initdata ( -- )

flist (assets)
: register  ( reloader-xt asset -- ) dup (assets) listlink  ( xt asset ) ! ;

\ TODO: change TRAVERSE> to EACH> after factoring out lists from obj.f
: assets>  postpone (assets)  postpone traverse> ; immediate

: srcfile  cell+ ;

\ As a convention, the first cell in every asset is a reloader XT.
: reload  ( asset -- )  ( asset -- )  dup @ execute ;

: #assets  (assets) listlen ;

: findfile
    2dup file-exists ?exit
    including -name #1 + 2swap strjoin 2dup file-exists ?exit
    true abort" File not found" ;

#256 cell+ constant /assetheader

: assetdef  ( -- <name> )  create /assetheader , ;

: .asset  srcfile count dup if  type  else  2drop  then ;
: .assets  assets> cr .asset ;

\ ------------------------------------------------------------------------------
\ Standard synchronous loader

: std-initdata  ( -- )  assets> reload ;
' std-initdata is initdata

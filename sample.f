defasset sample
    sample svar sample.smp
    sample svar sample.loop
: >smp  sample.smp @ ;

: reload-sample  ( sample - )
    >r  r@ srcfile count  findfile  zstring al_load_sample  r> sample.smp ! ;

: init-sample  ( looping adr c sample - )
    >r  r@ srcfile place  r@ sample.loop !  ['] reload-sample r@ register
    r> reload-sample ;

\ sample  create unnamed sample.  (redefining SAMPLE is a nice way of "sealing" the struct.)
\ sample:  create named sample
: sample   ( path c - sample )
    here >r  sample sizeof allotment init-sample  r> ; 
: sample:  ( loopmode adr c - <name> )
    create  sample  drop ;


defasset sample
    sample int svar sample.smp
    sample int svar sample.loop

: reload-sample  ( sample -- )
    >r  r@ srcfile count  findfile  zstring al_load_sample  r> sample.smp ! ;

: init-sample  ( looping adr c sample -- )
    >r  r@ srcfile place  r@ sample.loop !  ['] reload-sample r@ register
    r> reload-sample ;

\ sample  ( path c -- image )  create unnamed sample.  (redefining SAMPLE is a nice way of "sealing" the struct.)
\ sample:  ( loopmode adr c -- <name> )  create named sample
\ >smp  ( sample -- ALLEGRO_SAMPLE )
: sample   here >r  sample sizeof allotment init-sample  r> ; 
: sample:  create  sample  drop ;
: >smp  sample.smp @ ;


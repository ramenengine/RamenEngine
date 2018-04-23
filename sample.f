assetdef sample
    sample int svar sample.smp
    sample int svar sample.loop

: reload-sample  ( sample -- )
    >r  r@ srcfile count  zstring al_load_sample  r> sample.smp ! ;

: init-sample  ( looping adr c sample -- )
    >r  findfile r@ srcfile place  r@ sample.loop !  ['] reload-sample r@ register
    r> reload-sample ;

: sample:  ( loopmode adr c -- <name> )
    create sample sizeof buffer init-sample ;

: >smp  sample.smp @ ;


asset: %sample
    %sample svar sample.smp
    %sample svar sample.loop
: >smp  sample.smp @ ;

: reload-sample  ( sample - )
    >r  r@ srcfile count  findfile  zstring al_load_sample  r> sample.smp ! ;

: unload-sample
    sample.smp @ al_destroy_sample ;

: init-sample  ( looping adr c sample - )
    >r  r@ srcfile place  r@ sample.loop !  ['] reload-sample ['] unload-sample r@ register
    r> reload-sample ;

\ sample:  create named sample
: sample:   ( path c loopmode - >name> sample )
    -rot  create  %sample *struct init-sample ; 


assetdef %buffer
    %buffer int svar buffer.data
    %buffer int svar buffer.size

: recreate-buffer  ( buffer -- )
    >r  r@ buffer.size @ allocate throw  r> buffer.data ! ;

: init-buffer  ( size buffer -- )
    >r  dup r@ buffer.size !  allocate throw  r@ buffer.data !
    ['] recreate-buffer r> register ;

: buffer:   ( size -- <name> )
    create  %buffer sizeof buffer  init-buffer
    does>  buffer.data @ ; 
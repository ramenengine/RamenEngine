asset: %buffer
    %buffer svar buffer.data
    %buffer svar buffer.size

: recreate-buffer  ( buffer - )
    >r  r@ buffer.size @ allocate throw  r> buffer.data ! ;

: unload-buffer  ( buffer - )
    buffer.data @ free throw ;

: init-buffer  ( size buffer - )
    >r  dup r@ buffer.size !  allocate throw  r@ buffer.data !
    ['] recreate-buffer ['] unload-buffer r> register ;

: buffer  ( size - )
    %buffer *struct  init-buffer ;

: buffer:   ( size - <name> )
    create  buffer  does>  buffer.data @ ; 
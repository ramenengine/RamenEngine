
( curtain open effect )
: *curtain  stage *actor as draw> 128 256 black rectf ;
: curtain-open
    0 64 at *curtain 64 live-for -2 vx !
    128 64 at *curtain 64 live-for 2 vx !
; 

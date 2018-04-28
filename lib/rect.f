$000100 [version] rect-ver

struct rect
    rect int svar rect.x
    rect int svar rect.y
    rect int svar rect.w
    rect int svar rect.h

: x@    @ ;                       : x!    ! ;
: y@    cell+ @ ;                 : y!    cell+ ! ;
: w@    rect.w @ ;                : w!    rect.w ! ;
: h@    rect.h @ ;                : h!    rect.h ! ;
: xy@   2@ ;                      : xy!   2! ;
: wh@   rect.w 2@ ;               : wh!   rect.w 2! ;

: .rect  dup @xy 2. rot @wh 2. ;
: xywh@  4@ ;                     : xywh! 4! ;
: x2@   dup x@ swap w@ + ;        : x2@   >r r@ x@ - r> w! ;
: y2@   dup y@ swap h@ + ;        : y2@   >r r@ y@ - r> h! ;
: xy2@  dup 2@ rot wh@ 2+ ;       : xy2@  >r r@ xy@ 2- r> wh! ;

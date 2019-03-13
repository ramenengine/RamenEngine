\ essential "types"

struct %color
    %color svar color.r
    %color svar color.g 
    %color svar color.b
    %color svar color.a

struct %rect
    %rect svar rect.x
    %rect svar rect.y
    %rect svar rect.w
    %rect svar rect.h

: x@    @ ;                       : x!    ! ;
: y@    cell+ @ ;                 : y!    cell+ ! ;
: w@    rect.w @ ;                : w!    rect.w ! ;
: h@    rect.h @ ;                : h!    rect.h ! ;
: xy@   2@ ;                      : xy!   2! ;
: wh@   rect.w 2@ ;               : wh!   rect.w 2! ;
: xywh@  4@ ;                     : xywh! 4! ;
: x2@   dup x@ swap w@ + ;        : x2!   >r r@ x@ - r> w! ;
: y2@   dup y@ swap h@ + ;        : y2!   >r r@ y@ - r> h! ;
: xy2@  dup 2@ rot wh@ 2+ ;       : xy2!  >r r@ xy@ 2- r> wh! ;

: aabb@ xywh@ 2over 2+ ;

create srcrect  0 , 0 , 0 , 0 ,

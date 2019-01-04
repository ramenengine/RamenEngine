\ set this before calling TWEEN
create timespan 0 , 0 ,  \ delay , length ,  ( in frames )

objlist tweens

fields
    struct %tween  %tween to fields  redef on
    define tweening

        -1 value now  \ in frames

        %node @ %tween struct.size +!

        \ to prevent tweening objects that don't exist anymore
        var target <adr
        var targetid

        var dest <adr
        var start
        var change
        var ease <xt   

        var dawn  \ start time in frames
        var sunset  \ end time in frames

\        var storer <xt  
        var in/out <xt  
        
        ( optional ease params )
        var a  
        var b

    : dismiss  me dup >parent remove ;

    : store  ( val - ) dest @ ! ; \ storer @ execute ;

    : *tween  ( adr start end ease-xt in/out-xt - me=tween )
        me  tweens one  dup target ! 's id @ targetid ! 
        in/out !  ease !  over - change !  start !
        dest !
        timespan @ now + dup dawn !
            timespan cell+ @ + sunset !
        1.70158 a !
    ;
    
    : orphaned?  target @ 's id @ targetid @ <>  ;

    : +tween  ( - )
        now dawn @ < ?exit
        \ orphaned? if dismiss ;then
        start @  change @  now dawn @ - sunset @ dawn @ - / ( start change ratio )
            in/out @ execute ease @ execute store
        now sunset @ = if dismiss ;then
    ;
    
to fields  redef off

only forth definitions also tweening

: does-xt  does> @ ;
: :xt  create does-xt here 0 , :noname swap ! ;

\ ease modifiers ( start change ratio -- progress )
' noop constant in
:xt out
   negate 1.0 + >r swap over + swap negate r> ;
:xt inout
   dup 0.5 < if 2 * swap 2 / swap
   else swap 2 / rot over + -rot swap 0.5 - 2 * [ out compile, ] then ;

\ eases - all these describe the "in" animations, transformed by EASE-IN etc.
( startval ratio. change. -- val )
\ exponential formula: c * math.pow(2, 10 * (t / d - 1)) + b;
\ quadratic formula: c * (t /= d) * t + b

:xt LINEAR        * + ;
:xt EXPONENTIAL   1.0 - 10.0 * 2e 1pf f**  f>p * + ;
:xt SINE          90.0 * 90.0 - sin 1.0 + * + ;
:xt QUADRATIC     dup * * + ;
:xt CUBIC         dup * dup * * + ;
:xt QUARTIC       dup * dup * dup * * + ;
:xt QUINTIC       dup * dup * dup * dup * * + ;
:xt CIRCULAR      dup * 1.0 swap - sqrt 1.0 - * negate + ;
: (overshoot)     >r dup dup r@ 1.0 + * r> - * * * + ;
:xt OVERSHOOT     a @ (overshoot) ;

: ease  ( adr start end ease-xt in/out-xt - )
    { *tween } ;

: +tweens  ( - )
    1 +to now  tweens each> as +tween ;

previous

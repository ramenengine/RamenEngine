variable (delay)
variable (length)

\ call this before calling EASE
: timespan  ( delay length - )  \ in frames
   (length) ! (delay) ! ;

objlist tweens

fields
    struct %tween  %tween to fields  redef on
    define tweening

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
        
        ( optional ease param )
        var param

    : dismiss  me dup >parent remove ;

    : store  ( val - ) dest @ ! ; \ storer @ execute ;

    : *tween  ( adr start end ease-xt in/out-xt - me=tween )
        me  tweens one  dup target ! 's id @ targetid ! 
        in/out !  ease !  over - change !  start !
        dest !
        (delay) @ now + dup dawn !
            (length) @ + sunset !
    ;
    
    : orphaned?  ( - flag ) target @ 's id @ targetid @ <>  ;

    : +tween  ( adr start end ease-xt in/out-xt - )
        now dawn @ < ?exit
        orphaned? if dismiss ;then
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
   dup 0.5 < if  0.5 2 2*  ;then
   0.5 - #1 lshift >r #1 rshift dup u+ r> [ out compile, ]
;


( Ease functions )
\ all these describe the "in" animations, transformed by IN OUT and INOUT.

\ exponential formula: c * math.pow(2, 10 * (t / d - 1)) + b;
\ quadratic formula: c * (t /= d) * t + b

( startval ratio change -- val )
:xt LINEAR        * + ;
:xt EXPONENTIAL   1 - 10 * 2e 1pf f**  f>p * + ;
:xt SINE          90 * 90 - sin 1 + * + ;
:xt QUADRATIC     dup * * + ;
:xt CUBIC         dup * dup * * + ;
:xt QUARTIC       dup * dup * dup * * + ;
:xt QUINTIC       dup * dup * dup * dup * * + ;
:xt CIRCULAR      dup * 1 swap - sqrt 1 - * negate + ;
: overshoot-func  >r dup dup r@ 1 + * r> - * * * + ;
:xt OVERSHOOT     1.70158 overshoot-func ;

: ease  ( adr start end ease-xt in/out-xt - )
    { *tween } ;

: +tweens  ( - )
    tweens each> as +tween ;

previous

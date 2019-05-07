variable (delay)
variable (length)



create tweens _node static drop

_node sizeof 0 class: _tween
    
    \ to prevent tweening objects that don't exist anymore
    var target <adr
    var targetid
    
    var startval
    var dest <adr
    var delta
    var ease <adr
    
    var starttime  \ start time in frames
    var endtime    \ end time in frames
    
    \        var storer <xt  
    var in/out <word  
    
    ( optional ease param )
    var param
;class


define tweening

    : dismiss  dup >parent remove ;

    : store  ( val - ) dest @ ! ; \ storer @ execute ;

    : target!   dup target ! { ?id } ?dup if @ targetid ! then ;
    
    : orphaned?  ( - flag ) target @ { ?id } dup if @ targetid @ <> then ;

    : tween+  ( - )
        now starttime @ < ?exit
        orphaned? if me dismiss ;then
        startval @  delta @  now starttime @ - endtime @ starttime @ - / ( start delta ratio )
            in/out @ execute ease @ execute store
        now endtime @ = if me dismiss ;then
    ;
    

using tweening

: does-xt  does> @ ;
: :xt  create does-xt here 0 , :noname swap ! ;

\ ease modifiers ( start delta ratio -- progress )
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

( startval ratio delta -- val )
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

\ call this before calling TWEEN
: timespan  ( delay length - )  \ in frames
    (length) ! (delay) ! ;

: *tween  ( adr start end ease-xt in/out-xt - tween )
     me  _tween dynamic {
        me tweens push  target!
        in/out !  ease !  over - delta !  startval !
        dest !
        (delay) @ now + dup starttime !
           (length) @ + endtime !
     me }
;

: tween  ( adr start end ease-xt in/out-xt - )
    *tween drop ;

: tweento  ( adr end ease-xt in/out-xt - )
    2>r over @ swap 2r> tween ;

: tweens+  ( - )
    tweens each> as tween+ ;

stage actor: tweener
:now act> me stage push me { tweens+ } ;

previous

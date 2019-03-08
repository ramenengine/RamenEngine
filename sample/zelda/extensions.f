
( rolefields )
extend: _role
    8 cells field dropables
;class

( actions ) nr
action start ( - )
action idle ( - )
action walk ( - )
action turn ( angle )

( vars ) nr
extend: _actor 
    var hp
    var maxhp
    var atk
    var hp  
    var maxhp
    var dir \ angle
    var flags <hex
;class
_actor prototype as
    2 hp !
    2 maxhp !
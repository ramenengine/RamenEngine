var hp  2 defaults 's hp !
var damaged
var startx  var starty
action die ( - )
basis :to die ( - ) me dismiss ;

: !startxy x 2@ startx 2! ;


: -hp  ( n - )  hp +! damaged on hp @ ?exit die ;

: undamage  damaged off ;

: damage  ( n obj - )
    >{ damaged @ not if -hp ['] undamage 60 after else drop then } ;

: ~weapons  \ weapon interaction
    with stage each> as #weapon hit? if -1 you damage then 
;


: orbit  !startxy perform> 0 begin dup 16 vec startx 2@ 2+ x 2! over + pause again ;
    
: rndcolor  1 rnd 1 rnd 1 rnd rgb ;
    
: /orb  draw> 8 8 +at  pixalign  8 8 damaged @ if rndcolor else blue then circf ;
: *orb  spawn /orb -5 orbit act> ~weapons ;

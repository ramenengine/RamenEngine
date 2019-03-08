( some helpers )

_actor fields:                                              \ add some variables to the _ACTOR class
    var onground <flag  var hitceiling <flag
    var dir

: ?onground  floor? if onground on then ;
: ?hitceiling  ceiling? if hitceiling on then ;
: handle-hits  ?onground  ?hitceiling ;

: gravity  0.17 vy +!  vy @ 2.6 min vy ! ;                  \ caps vy at 2.6
: /solid   14 14 mbw 2! ['] handle-hits onmaphit !          \ map box = 14x14
    physics> gravity onground off hitceiling off tilebuf collide-tilemap ;  \ we do tilemap collision here

: tile@  ( x y - n )  16 16 2/ tilebuf loc @ ;
: tile!  ( n x y - )  16 16 2/ tilebuf loc ! ;
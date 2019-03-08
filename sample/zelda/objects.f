
( object types - maintain the ordering to keep savestates coherent )
type: link
type: test
type: sword
type: bomb
type: potion
type: rupee
type: orb
type: statue
type: swordattack
type: dude


: body>name  body> >name ccount ;
: load-types  typeRoles each> body>name s" sample/zelda/obj/" s[ +s s" .f" +s ]s included ;
load-types

( actor extensions )
extend: _actor
    var clipx  var clipy
    var startx  var starty
    %rect sizeof field ihb  \ interaction hitbox; relative to x,y position
    var 'physics  \ code
    var flags <hex
    var dir \ angle
;class
_actor >prototype as
    0 0 16 16 ihb xywh!

( misc )
: situate  at@ x 2! ;
: -vel    0 0 vx 2! ;
: /clipsprite  x 2@ clipx 2!  draw> clipx 2@ cx 2@ 2- 16 16 clip> sprite ;
: ipos  x 2@ ihb xy@ 2+ ;
: toward  ( obj - x y )  { ipos } ipos 2- angle uvec ;
: !startxy x 2@ startx 2! ;
: bit#  ( bitmask - n )  #1 32 for 2dup and if 2drop i unloop ;then 1 << loop 2drop -1 ;

( actor collisions )
0 value you
: ibox  ( - x y x y )  x 2@ ihb xy@ 2+ ihb wh@ aabb 1 1 2- ;
: with  ( - ) me to you ;
: hit?  ( attributes - flag )  \ usage: <subject> as with ... <object> as <bitmask> hit?
    flags @ and 0= if 0 ;then
    me you = if 0 ;then
    ibox you { ibox } overlap? ;
: draw-ibox  ibox 2over 2- 2swap 2pfloor at red 1 1 2+ rect ;
:slang on-top  act> me stage push ;
: show-iboxes  stage *actor as  on-top  draw> stage each> as draw-ibox ;

( actor spawning )
stage value spawner
variable spawndir
\ defer spawn 
: spawn  me to spawner  me ihb xy@ from  dir @ spawndir ! ;
\ : map-spawn  <-- how object spawners will "know" a map or room is being loaded.


( quest state )
create quest  64 kbytes /allot
quest value quest^
: quest-field  quest^ constant +to quest^ ;
: quest-var  cell quest-field ;


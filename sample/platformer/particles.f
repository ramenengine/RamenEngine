\ the bottleneck is probably rendering.  could be sped up by drawing a vertex list.

_node sizeof  32 cells  class: _particle
    var x var y var vx var vy
    var fric var lifetime var lifespan var gnd
    var fr <float var fg <float var fb <float var fa <float
    var ax var ay var afade <float
;class
_particle >prototype as
    1 fric !
    1 1 1 1 4af fr 4!

objlist: particles

variable groundy

: *particle  ( lifespan - obj )
    _particle dynamic { lifespan !
    me particles push  at@ x 2!
    groundy @ gnd !  fore 4@ fr 4!
    me } ;

_particle :- die  me destroy ;
_particle :- expired  lifetime @ lifespan @ >= ;
_particle :- stopped  lifetime @ 10 >=  y @ pfloor gnd @ 1 - >= and  vy @ abs 0.2 < and ;
_particle :- ?die  lifetime ++  expired stopped or if r> drop die then ;
_particle :- fade  fa sf@ afade sf@ f- fa sf! ;
_particle :- friction  vx 2@ fric @ dup 2* vx 2! ;
_particle :- accel  ax 2@ vx 2+! ;
_particle :- bounce  y @ gnd @ min y !  vy @ -0.8 -0.33 between * vy !  vy @ abs 0.5 < ?exit
    vx @ -0.25 0.25 between + vx ! ;
_particle :- ?bounce  gnd @ -exit  y @ vy @ + gnd @ >= -exit  bounce r> drop ;
_particle :- step  ?die ?bounce accel friction vx 2@ x 2+! ;
_particle :+ +particles  particles each> as step fade ;
_particle :- draw  fr 4@ fore 4! x 2@ at  pixel ;
_particle :+ draw-particles  cam view> particles each> as draw ;

particles as  :now  draw> me { draw-particles } act> +particles ;
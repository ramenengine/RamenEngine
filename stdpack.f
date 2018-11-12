\ Standard library set
\ Very general purpose

depend ramen/lib/std/rangetools.f
depend ramen/lib/std/task.f
depend ramen/lib/std/cgrid.f
depend ramen/lib/std/zsort.f
depend ramen/lib/std/v2d.f
depend ramen/lib/std/kb.f
depend ramen/lib/std/audio1.f
depend ramen/lib/std/sprites.f
depend ramen/lib/std/tilemap.f
depend ramen/lib/tiled/tiled.f

: acts  each> act ;
: think  stage dup acts multi ;
: physics  stage each> vx 2@ x 2+! ;
:now  step> think physics ;

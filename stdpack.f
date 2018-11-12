\ Standard library set
\ Very general purpose

depend ramen/lib/rangetools.f
depend ramen/lib/zsort.f
depend ramen/lib/draw.f
depend ramen/lib/v2d.f
depend ramen/lib/cgrid.f
depend ramen/lib/task.f
depend ramen/lib/kb.f
depend ramen/lib/audio1.f
depend ramen/lib/sprites.f
depend ramen/lib/tiled.f

: acts  each> act ;
: think  stage dup acts multi ;
: physics  stage each> vx 2@ x 2+! ;
:now  step> think physics ;

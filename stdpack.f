\ Standard library set
\ Very general purpose

require ramen/lib/rangetools.f
require ramen/lib/zsort.f
require ramen/lib/draw.f
require ramen/lib/v2d.f
require ramen/lib/cgrid.f
require ramen/lib/task.f
require afkit/lib/kb.f
require ramen/lib/audio1.f
require ramen/lib/sprites.f
require ramen/lib/tiled.f

: acts  each> act ;
: think  stage dup acts multi ;
: physics  stage each>  vx 2@ x 2+! ;

:now  step>  think  physics ;

empty
$000100 include ramen/brick
$000100 include ramen/lib/stage
$10000 include ramen/tiled/tiled


" ramen/test/island/island.tmx" loadnewtmx  constant map  constant dom

only forth definitions also xmling also tmxing

\ map 0 tileset[] drop constant ts constant tsdom
map 0 loadtileset

map " Ground" layer  0 0 tilebuf loc  tilebuf pitch@  readlayer
map " Ground" layer  0 0 loadtilemap \ same thing but also converts the data

: -act  act> noop ;
cam as  -act

create tm object  /tilemap  50 50 x 2!  300 300 w 2!

\ scroll the tilemap
: bounce  1 1 vx 2!  act>
    vx @ 0< if  x @ 0 < if  vx @ negate vx !  then then
    vy @ 0< if  y @ 0 < if  vy @ negate vy !  then then
    vx @ 0> if  x @ 600 >= if  vx @ negate vx !  then then
    vy @ 0> if  y @ 450 >= if  vy @ negate vy !  then then
    vx 2@ tm 's scrollx 2+! ;


create dummy  stage 1 add  10 15 x 2!  enable  bounce

: (show)  show>  black backdrop  tm -> draw   subject track  camtrans  stage drawzsorted ;

go (show) ok
empty
$000100 include ramen/brick
$10000 include ramen/tiled/tiled

" ramen/test/island/island.tmx" loadtmx  constant map  constant dom

only forth definitions also xmling also tmxing

map 0 tileset[] drop constant ts constant tsdom

map " Ground" layer  0 0 tilebuf loc  tilebuf pitch@  readlayer
map " Ground" layer  0 0 loadtilemap \ same thing but also converts the data

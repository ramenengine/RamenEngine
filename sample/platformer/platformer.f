include ramen/ramen.f           \ goes first

empty                           \ closes and frees any previous project
project: sample/platformer      \ sets the project's root folder so that LD knows where to look

ld preamble                     \ loads dependencies and sets up some global stuff like upscaling
ld map                          \ loads the map data
ld helpers                      \ physics and tile stuff
ld particles                    \ simple particle system
ld break                        \ effect to turn tiles into particles

( ---=== set up playfield ===--- )
stage actor: blackness  ld blackness
stage actor: bg0  ld bg
particles stage push
stage actor: guy  ld player
ld camera

( define initialization code for exported game )
:make cold
    reload                   \ reload the tilemap data
;

( test stuff )
: test  guy 0 0 from stage *actor as blue /b6ox ;
:now stage *actor as act> <t> pressed if test then ;

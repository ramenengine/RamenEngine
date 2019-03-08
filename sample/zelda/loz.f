include ramen/ramen.f           \ goes first
project: sample/zelda           \ sets the project's root folder so that LD knows where to look

( engine-y stuff: )
ld preamble     \ config and dependencies (such as the standard pack)     
ld ui           \ development ui
ld tools        \ zelda-specific toolkit
ld common       \ "common object" framework
ld globals      \ global variables
ld map          \ words for loading and working with map data
ld constants    \ flags and things
ld extensions   \ project-wide extensions for classes
ld etc          \ more global higher-level words
ld curtain      \ curtain open effect
ld motions      \ canned motions for actors
ld item         \ item-related words
ld npc          \ npc-related words
ld loop         \ customized game loop

( game specific stuff: )
ld hud          \ all the status stuff like health and the minimap
ld objects      \ all our game's object definitions
ld worlds       \ world data
ld events       \ global event handlers; brings various things together (kind of like MMF or Construct)
ld setup        \ initialization and switching between modes

( define initialization code for exported game )
:make cold
    reload                   \ reload the tilemap data
;


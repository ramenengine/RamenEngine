( global variables and savestate )

\ #16 quest-field player
2 cells quest-field coords  3 3 coords 2!
quest-var room#
quest-var world#
quest-var in-cave
quest-var tempx  quest-var tempy
quest-var maxbombs  8 maxbombs !
quest-var maxpotions 1 maxpotions !

tilebuf 0 0 32 32 section2d: roombuf 

0 value world          \ pointer to a _world

stage actor: bg0  
include sample/zelda/printer.f
stage actor: cam
stage actor: hud
stage actor: minimap
stage actor: link0  
: p1  link0 ;

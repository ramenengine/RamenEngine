
: /bg   bg0 as /tilemap 256 256 w 2! ; <ui
: /cam  cam as act> x 2@ bg0 's scrollx 2! ; <ui

: /ui  /hud /minimap ;
: /playfield  /bg /cam /ui ;
: /overworld
    /playfield
    /link 64 96 x 2!
    overworld 
;
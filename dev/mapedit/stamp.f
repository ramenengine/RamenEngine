( tilemap clipboard )
64 64 array2d: cpbuf
tilebuf 0 0 64 64 section2d: tmsel
: tilewh/  tilea 's w 2@ 2/ ;
: stampify
    mapa 's scrollx 2@ tilewh/ 2pfloor 
    mapa 's w 2@ tilewh/ 2pfloor 2dup cpbuf array2d.cols 2!
        srcrect xywh!    
    tmsel cpbuf 0 0 put2d
;

: stamp
    cpbuf tilebuf  mapa 's scrollx 2@ tilewh/ 2pfloor put2d
;

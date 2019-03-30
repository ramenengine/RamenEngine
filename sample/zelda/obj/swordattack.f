type: swordattack
    swordattack :to setup  #directional #weapon or flags ! ;
    : in-front 
        dir @ case
            0 of   12 2 x 2+! 14 ihb h! endof
            270 of 0 -12 x 2+! endof
            180 of -12 2 x 2+! 14 ihb h! endof
            90 of  0 12 x 2+! endof
        endcase ;
    : retract  /clipsprite dir @ 180 + 4 vec vx 2! ;
    swordattack :to start  in-front evoke-sword ;
    : swordstab  spawn *swordattack ['] retract 7 after 9 live-for ;
    :listen
        s" player-swung-sword" occurred if
            p1 me { swordstab }
        ;then   
    ;

    



( sword )
: in-front 
    dir @ case
        0 of 12 2 x 2+! 14 ihb h! endof
        270 of 0 -12 x 2+! endof
        180 of -12 2 x 2+! 14 ihb h! endof
        90 of 0 12 x 2+! endof
    endcase ;
: *sword  #sword *item anim-swordu ;
: retract  /clipsprite dir @ 180 + 4 vec vx 2! ;
: *sword-attack
    #sword *item /weapon in-front evoke-sword
    ['] retract 7 after 9 live-for ;

:listen
    s" player-swung-sword" occurred if
        p1 from { *sword-attack }
    ;then
    s" player-entered-cave" occurred if
        #sword have not if 128 8 - 128 at *sword then
    ;then
;
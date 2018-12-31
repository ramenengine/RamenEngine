    
weapon-regions weapons.image 0 autoanim: anim-swordr 0 , ;anim
weapon-regions weapons.image 0 autoanim: anim-swordl 0 h, ;anim
item-regions items.image 0 autoanim: anim-swordu 0 , ;anim
item-regions items.image 0 autoanim: anim-swordd 0 v, ;anim

create evoke-sword dir-anim-table
    ' anim-swordr ,
    ' anim-swordd ,
    ' anim-swordl ,
    ' anim-swordu ,
    


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

( others )
: *bomb    #bomb *item   4 quantity !  draw> 1 nsprite ;
: *potion  #potion *item draw> 2 nsprite ;

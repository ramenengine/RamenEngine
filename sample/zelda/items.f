    
weapon-regions weapons.image 0 autoanim: anim-swordr 0 , ;anim
weapon-regions weapons.image 0 autoanim: anim-swordl 0 h, ;anim
item-regions items.image 0 autoanim: anim-swordu 0 , ;anim
item-regions items.image 0 autoanim: anim-swordd 0 v, ;anim

create evoke-sword dir-anim-table
    ' anim-swordr ,
    ' anim-swordd ,
    ' anim-swordl ,
    ' anim-swordu ,
    
: in-front 
    dir @ case
        0 of 12 2 x 2+! 14 ihb h! endof
        270 of 0 -12  x 2+! endof
        180 of -12 2 x 2+! 14 ihb h! endof
        90 of 0 12 x 2+! endof
    endcase ;


( sword )
: *sword  #sword *item anim-swordu ;
: *sword-attack  #sword *item /weapon in-front evoke-sword ;
: retract  /clipsprite dir @ 180 + 6 vec vx 2! ;
:listen
    s" player-swung-sword" occurred if
        p1 from *sword-attack ['] retract 10 after 12 live-for 
    ;then
;

( others )
: *bomb    #bomb *item   draw> 1 nsprite ;
: *potion  #potion *item draw> 2 nsprite ;


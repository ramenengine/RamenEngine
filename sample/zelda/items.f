s" weapon-sprites.png" >data image: weapons.image
s" item-sprites.png" >data image: items.image

create weapon-regions
    2 , 1 , 16 , 16 , 0 , 0 , \ 0 wood sword (right)

create item-regions
    104 , 0 , 8 , 16 , -4 , 0 , \ 0 wood sword (up)
    136 , 0 , 8 , 16 , -4 , 0 , \ 1 bomb
    80 , 0 , 8 , 16 , -4 , 0 ,  \ 2 potion
    

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

: /weapon  #weapon attributes ! ;
: *item  ( itemtype - )
    spawn itemtype !
    /sprite item-regions rgntbl ! items.image img ! 
    #important +flag
    ;

( sword )
: *sword  #sword *item evoke-sword ;
: *sword-attack  *sword /weapon in-front ;
: retract  /clipsprite dir @ 180 + 6 vec vx 2! ;
:listen
    s" player-swung-sword" occurred if
        p1 from *sword-attack ['] retract 10 after 12 live-for 
    ;then
;

( others )
: *bomb    #bomb *item   draw> 1 pixalign nsprite ;
: *potion  #potion *item draw> 2 pixalign nsprite ;


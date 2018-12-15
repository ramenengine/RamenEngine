s" weapon-sprites.png" >data image: weapons.image
s" item-sprites.png" >data image: items.image

create weapon-regions
    2 , 1 , 16 , 16 , 0 , 0 , \ wood sword (right)

create item-regions
    104 , 0 , 8 , 16 , -4 , 0 , \ wood sword (up)

weapon-regions weapons.image 0 autoanim: anim-swordr 0 , ;anim
weapon-regions weapons.image 0 autoanim: anim-swordl 0 h, ;anim
item-regions items.image 0 autoanim: anim-swordu 0 , ;anim
item-regions items.image 0 autoanim: anim-swordd 0 v, ;anim

create evoke-sword dir-anim-table
    ' anim-swordr ,
    ' anim-swordu ,
    ' anim-swordl ,
    ' anim-swordd ,
    
    
: in-front  ( angle ) dir !
    dir @ case
        0 of 12 -6 x 2+! endof
        90 of 0 -20  x 2+! endof
        180 of -12 -6 x 2+! endof
        270 of 0 4 x 2+! endof
        
    endcase ;
: *sword  me 0 0 away dir @ stage one /sprite in-front evoke-sword ;

: live-for  perform> pauses me dismiss ;

:listen
    s" player-swung-sword" occured if
        *sword 10 live-for
    then
;